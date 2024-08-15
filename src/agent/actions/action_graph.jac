node actions {

}

node action {
    has name: str;
    has description: str = "basic agent action";
    has anchors: list = [];
    has enabled: bool = True;

    can touch;
    # can execute;
    # can pulse;

}

node exit_action :action: {
# core exit action is always present on all action graphs at the very end of the graph
# it serves to directly reference with take to force the interact walker to exit and return
    has name: str = "exit_action";
    has description: str = "core exit action node for walker cleanup and return";
    has self_graph: bool = False; # prevent from graphing

}
