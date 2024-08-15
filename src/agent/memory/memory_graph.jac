node memory {
    has child_graph: bool = False;
}

edge retrace {

}

edge advance {

}

edge tail {

}

node frame {
    has session_id: str;
    has agent_id: str;
    has variables: dict = {};   
}

node interaction {
    has channel: str;
    has utterance: str;
    has intent: list = []; # this holds the node names of actions which must be executed; capable of multiple intent executions...
    has trail: list = [];
    has context_data: dict = {};
    has response: dict = {
        "type": "TEXT", # TEXT, MEDIA, SILENCE, MULTI (collection of mixed types) 
        "message": ""
    };
}

node entity {
    # an extracted entity related to an interaction
    has label: str;
    has texts: str;
    has confidence: int;
}

node data {
    # an extracted data item related to an interaction
    has label: str;
    has data_type: str;
    has content: str;
}



