export const NotificationBellPlugin = async ({ $ }) => {
  let lastBellAt = 0;
  let lastHumanInputAt = 0;

  const MIN_BELL_INTERVAL_MS = 1200;
  const IDLE_AFTER_INPUT_SUPPRESS_MS = 2500;

  const runDetached = async (command, args) => {
    if (typeof Bun !== "undefined") {
      Bun.spawn([command, ...args], {
        stdin: "ignore",
        stdout: "ignore",
        stderr: "ignore",
      });
      return;
    }

    await $`afplay ${args[0]}`;
  };

  const playMacSound = async () => {
    try {
      await runDetached("afplay", ["/System/Library/Sounds/Glass.aiff"]);
      return true;
    } catch {
      return false;
    }
  };

  const ringBell = async (eventType) => {
    const now = Date.now();

    if (now - lastBellAt < MIN_BELL_INTERVAL_MS) return;
    if (
      eventType === "session.idle" &&
      now - lastHumanInputAt < IDLE_AFTER_INPUT_SUPPRESS_MS
    )
      return;

    try {
      if (process.platform === "darwin") {
        const played = await playMacSound();

        if (!played) {
          process.stdout.write("\x07");
        }
      } else {
        process.stdout.write("\x07");
      }
    } catch {
      process.stdout.write("\x07");
    }

    lastBellAt = now;
  };

  return {
    event: async ({ event }) => {
      if (
        event.type === "permission.asked" ||
        event.type === "question.asked"
      ) {
        lastHumanInputAt = Date.now();
        await ringBell(event.type);
        return;
      }

      if (event.type === "session.idle") {
        await ringBell(event.type);
      }
    },
  };
};
