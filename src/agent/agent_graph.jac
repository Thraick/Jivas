import:py yaml;
import:py modules.utils as utils;
import:jac from memory.memory_graph, memory;
import:jac actions.action_graph_lib;

glob descriptor_root = "/jivas-data/";

node app {}

node agents {}

node agent {
    has name: str;
    has description: str = "";
    has descriptor: str = "";
    has id: str = utils.generate_unique_id();
    has context: dict = {};
    has meta: dict = {};
    has published: bool = True;

}

walker go_to_agents {

    can enter with `root entry {
        print("Visiting app node");
        visit [-->](`?app);
    }

    can go_to_agents with app entry {
        print("Visiting agents node");
        visit [-->](`?agents);
    }
}

walker go_to_agent :go_to_agents: {
    has agent_name: str;

    can go_to_agent with agents entry {
        visit [-->](`?agent)(?name == agent_name);
    }
}

walker import_agent :go_to_agents: {
    has agent_data: dict = {};
    has agent_yaml: str = "";
    has reporting: bool = True;

    can create_agent with agents entry;
    can update_agent with agent entry;
}

walker update_agent :go_to_agent: {
    has agent_data: dict = {};
    has protected_attrs: list = [
        "published", "name", "description", "children", "enabled", "descriptor", "meta"
    ];

    can update_agent with agent entry;
}

walker delete_agent :go_to_agents: {
    has agent_name: str;
    has reporting: bool = True;

    can delete_agent with agents entry;
}

walker export_agent :go_to_agent: {

    can export_agent with agent entry;
}

walker get_agent :go_to_agent: {
    can get_agent with agent entry;
}

walker list_agents :go_to_agents: {

    can list_agents with agents entry {
        agents = [-->](`?agent);
        report agents;
    }
}

walker init_agents :go_to_agents: {
    can init_agents with agents entry;
}