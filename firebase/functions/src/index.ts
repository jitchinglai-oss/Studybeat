import { initializeApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";
import { onDocumentWritten } from "firebase-functions/v2/firestore";
import { onCall, HttpsError } from "firebase-functions/v2/https";
import { defineSecret } from "firebase-functions/params";
import OpenAI from "openai";

initializeApp();
const db = getFirestore();
const openaiKey = defineSecret("OPENAI_API_KEY");

/**
 * Called by the app every ~15 minutes during a session.
 * Returns adapted music parameters based on focus + stress.
 */
export const adaptSoundscape = onCall(
  { secrets: [openaiKey] },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "Sign in required.");
    }

    const {
      theme,
      focusLevel,
      stressLevel,
      elapsedMinutes,
      totalMinutes,
      currentBpm,
      currentRichness,
    } = request.data as {
      theme: string;
      focusLevel: string;
      stressLevel: string;
      elapsedMinutes: number;
      totalMinutes: number;
      currentBpm: number;
      currentRichness: number;
    };

    // Deterministic rule layer (Phase 1–2). Optional LLM polish below.
    let bpm = currentBpm ?? 60;
    let richness = currentRichness ?? 0.45;
    let ambientIntensity = 0.5;
    let note = "Holding current mix";

    if (focusLevel === "excellent") {
      richness = Math.min(1, richness + 0.12);
      note = "Focus excellent — enriching instrumentation";
    } else if (focusLevel === "distracted") {
      richness = Math.max(0.15, richness - 0.15);
      ambientIntensity = 0.65;
      note = "Distracted — simplifying layers";
    } else if (focusLevel === "overwhelmed") {
      richness = Math.max(0.1, richness - 0.25);
      bpm = Math.max(40, bpm - 6);
      ambientIntensity = 0.75;
      note = "Overwhelmed — slowing tempo, boosting ambience";
    }

    if (stressLevel === "high" || stressLevel === "overwhelmed") {
      bpm = Math.max(40, bpm - 4);
      ambientIntensity = Math.min(1, ambientIntensity + 0.1);
    }

    const progress = totalMinutes ? elapsedMinutes / totalMinutes : 0;
    const brightness = progress > 0.5 ? Math.min(0.9, 0.3 + (progress - 0.5) * 0.8) : 0.3;

    // Optional: ask OpenAI for a short coach line (fails soft).
    let coachLine: string | null = null;
    try {
      const client = new OpenAI({ apiKey: openaiKey.value() });
      const completion = await client.chat.completions.create({
        model: "gpt-4o-mini",
        max_tokens: 60,
        messages: [
          {
            role: "system",
            content:
              "You are Studybeat, a calm study coach. One short sentence max.",
          },
          {
            role: "user",
            content: `Theme ${theme}, focus ${focusLevel}, stress ${stressLevel}, minute ${elapsedMinutes}/${totalMinutes}. Encourage briefly.`,
          },
        ],
      });
      coachLine = completion.choices[0]?.message?.content?.trim() ?? null;
    } catch {
      coachLine = null;
    }

    return {
      bpm,
      richness,
      ambientIntensity,
      brightness,
      hasVocals: false,
      transitionNote: note,
      coachLine,
    };
  }
);

/**
 * Aggregate weekly stats when a session is completed.
 */
export const onSessionWrite = onDocumentWritten(
  "users/{userId}/sessions/{sessionId}",
  async (event) => {
    const after = event.data?.after?.data();
    if (!after || after.status !== "completed") return;

    const userId = event.params.userId;
    const weekId = weekKey(new Date(after.completedAt ?? Date.now()));
    const statsRef = db.doc(`users/${userId}/stats/${weekId}`);

    await db.runTransaction(async (tx) => {
      const snap = await tx.get(statsRef);
      const current = snap.data() ?? {
        studyMinutes: 0,
        sessionsCompleted: 0,
        themeCounts: {},
        xpEarned: 0,
      };
      const themeCounts = { ...(current.themeCounts as Record<string, number>) };
      const theme = after.musicTheme as string;
      themeCounts[theme] = (themeCounts[theme] ?? 0) + 1;

      tx.set(
        statsRef,
        {
          studyMinutes: (current.studyMinutes as number) + (after.durationMinutes as number),
          sessionsCompleted: (current.sessionsCompleted as number) + 1,
          themeCounts,
          xpEarned: (current.xpEarned as number) + ((after.xpEarned as number) ?? 0),
          updatedAt: new Date().toISOString(),
        },
        { merge: true }
      );
    });
  }
);

/**
 * Generate AI coach insights from recent session history.
 */
export const generateCoachInsights = onCall(
  { secrets: [openaiKey] },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "Sign in required.");
    }
    const userId = request.auth.uid;
    const sessionsSnap = await db
      .collection(`users/${userId}/sessions`)
      .where("status", "==", "completed")
      .orderBy("completedAt", "desc")
      .limit(20)
      .get();

    const sessions = sessionsSnap.docs.map((d) => d.data());
    if (sessions.length === 0) {
      return { insights: [] };
    }

    const summary = sessions
      .map(
        (s) =>
          `${s.subject} ${s.durationMinutes}m theme=${s.musicTheme} stress=${s.stressLevel}`
      )
      .join("\n");

    let insights: Array<{ message: string; category: string }> = [];
    try {
      const client = new OpenAI({ apiKey: openaiKey.value() });
      const completion = await client.chat.completions.create({
        model: "gpt-4o-mini",
        response_format: { type: "json_object" },
        messages: [
          {
            role: "system",
            content:
              'Return JSON { "insights": [{ "message": string, "category": "productivity"|"focus"|"music"|"break" }] } with 3 insights.',
          },
          { role: "user", content: summary },
        ],
      });
      const parsed = JSON.parse(completion.choices[0]?.message?.content ?? "{}");
      insights = parsed.insights ?? [];
    } catch {
      insights = [
        {
          message: "Your focus drops after long blocks. Try a mid-session break.",
          category: "focus",
        },
      ];
    }

    const batch = db.batch();
    insights.forEach((insight, i) => {
      const ref = db.collection(`users/${userId}/insights`).doc();
      batch.set(ref, {
        ...insight,
        createdAt: new Date().toISOString(),
        order: i,
      });
    });
    await batch.commit();

    return { insights };
  }
);

function weekKey(date: Date): string {
  const d = new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate()));
  const dayNum = d.getUTCDay() || 7;
  d.setUTCDate(d.getUTCDate() + 4 - dayNum);
  const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
  const weekNo = Math.ceil(((d.getTime() - yearStart.getTime()) / 86400000 + 1) / 7);
  return `${d.getUTCFullYear()}-W${String(weekNo).padStart(2, "0")}`;
}
