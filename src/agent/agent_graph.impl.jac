:walker:import_agent:can:create_agent {

    data = {};

    if (not self.agent_data and not self.agent_yaml) {
        report {
            "error": "agent_data or agent_yaml not provided"
        };
    }

    if (self.agent_data) {
        data = self.agent_data;
    } else {
        try {
            data = yaml.safe_load(self.agent_yaml);
        } except Exception as e {
            report {
                "error": "failed to load yaml"
            };
        }
    }

    # Update agent node if exists or create new
    visit [-->](`?agent)(?name == data["name"] or id == data["id"]) else {
        print("Creating new agent:", data["name"]);

        agent_node = here ++> agent(
            name=data["name"],
            description=data["description"]
        );

        print("Agent Node:", agent_node);

        visit agent_node;
    }
}

:walker:import_agent:can:update_agent {
    
    :g:descriptor_root;

    # Update agent descriptor path
    descriptor_path = f"{descriptor_root}/{here.name}_{here.id}.yaml";
    here.descriptor = descriptor_path;

    # Attach memory and actions node
    memory_node = here ++> memory();
    actions_node = here ++> actions();

    wlk = here spawn update_agent(agent_name=here.name,agent_data=self.agent_data);
}

:walker:update_agent:can:update_agent {
    print("Updating agent:", here.name);

    # Update agent context
    for attr in self.agent_data {
        here.context[attr] = self.agent_data[attr];
    }

    # Get actions node
    actions_node = [-->](`?actions);

    # Update actions
    if (self.agent_data["actions"]) {
        for action in self.agent_data["actions"] {
            # TODO: Implement action update
        }

        # Add exit action
        here ++> exit_action();
    }

    # Export agent to descriptor
    export_agent(agent_name=here.name) spawn here;
    
}

:walker:delete_agent:can:delete_agent {
    print("Deleting agent:", self.agent_name);

    # Get agent node
    agent_node = [-->](`?agent)(?name == self.agent_name);

    # Delete agent node
    here del--> agent_node;

    if (self.reporting) {
        report agent_node;
    }
}

:walker:get_agent:can:get_agent {
    print("Getting agent:", here.name);

    report here;
}

:walker:export_agent:can:export_agent {
    print("Exporting agent:", here.name);

    # TODO: Implement agent exportation
    report here;

}

:walker:list_agents:can:list_agents {
    agents = [-->](`?agent);
    report agents;
}

:walker:init_agents:can:init_agents {
    agents = [-->](`?agent);
    for agent in agents {
        print("Initializing agent:", agent.name);
        
        agent_data = yaml.safe_load(agent.descriptor);
        update_agent(agent_data) spawn agent;

    }
}