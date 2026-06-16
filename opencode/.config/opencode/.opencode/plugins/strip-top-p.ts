import type { Plugin } from "@opencode-ai/plugin";

export default (async () => {
    return {
        config: (cfg) => {
            for (const [name, agent] of Object.entries(cfg.agent ?? {})) {
                if (!name.includes("betika")) continue;
                delete agent.topP;
                delete agent.options?.topP;
                delete agent.options?.top_p;
            }
        },
        "chat.params": async (input, output) => {
            const providerID = input.provider?.info?.id ?? input.model?.providerID;
            if (providerID !== "gateframe") return;

            delete output.topP;
            delete output.options?.top_p;
            delete output.options?.topP;
        },
    };
}) satisfies Plugin;
