import:py from jaclang_jaseci.utils, ElasticConnector, start_elastic_logger;
import:py from jaclang_jaseci, start, FastAPI;
import:py from fastapi.middleware.cors, CORSMiddleware;
import:jac from agent.agent_graph, app, agent, agents;

can server_run {    
    FastAPI.get().add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"]
    );
    ElasticConnector.configure(url="http://elasticsearch:9200");
    start_elastic_logger(index="jivas");
    start(host="0.0.0.0", port=8000);
}

walker init_app {
    can init_app with `root entry {
        # Visit app node if exists or create new
        visit [-->](`?app) else {
            app_node = here ++> app();
            visit app_node;
        }
    }

    can init_agents with app entry {
        visit [-->](`?agents) else {
            agents_node = here ++> agents();
            visit agents_node;
        }
    }

    can list_agents with agents entry {
        print("Jivas App Initialized! 🚀");
        agents = [-->](`?agent);
        if (agents) {
            report {
                "agents": agents
            };
        } else {
            print("No agents found!");
            report {
                "agents": []
            };
        }
    }

}

with entry:__main__ {
    server_run();
}