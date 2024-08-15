import:jac from ..action_graph, action;

node whitelist_action :action: {
    has name: str;
    has description: str = "manages whitelisted contacts and permits only these contacts access to interact";
    has whitelist: list = []; # list of whitelisted contacts
    has enabled: bool = True;
}

walker apply_whitelist_action {
    has session_id: str;

    can apply_whitelist_action with whitelist_action entry;
}