import path from "node:path";

export const WindowTitlePlugin = async ({ directory }) => {
  const sanitize = (value) => value.replace(/[\u0000-\u001f\u007f\u009b\u001b]/g, "");
  const label = path.basename(directory) || directory;

  const setTitle = () => {
    if (!process.stdout.isTTY) return;

    const title = sanitize(`opencode - ${label}`);
    process.stdout.write(`\u001b]0;${title}\u0007`);
  };

  setTitle();

  return {
    event: async ({ event }) => {
      if (
        event.type === "server.connected" ||
        event.type === "session.created" ||
        event.type === "session.updated" ||
        event.type === "session.idle"
      ) {
        setTitle();
      }
    },
  };
};
