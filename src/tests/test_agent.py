import yaml
import requests
from dataclasses import dataclass
from dataclasses_json import dataclass_json, Undefined
from config import INSTANCE_URL
from test_user import headers
from test_app import init_app

AGENT_DATA = yaml.safe_load(open('fixtures/test_agent.yaml'))

@dataclass_json(undefined=Undefined.EXCLUDE)
@dataclass
class Agent:
    id: str
    name: str
    description: str
    descriptor: str
    context: dict
    meta: dict
    published: bool

def test_import_agent(headers, init_app):
    response = requests.post(
        f"{INSTANCE_URL}/walker/import_agent",
        headers=headers,
        json={
            "agent_data": AGENT_DATA
        },
    )
    assert response.status_code == 200

    # Assert dataclass matches response and news field are added to agent
    agent = Agent(**response.json()["reports"][0]["context"])
    assert hasattr(agent, "id") and agent.id != ""
    assert hasattr(agent, "descriptor") and agent.descriptor != ""
    assert agent.name == AGENT_DATA["name"]
    assert agent.description == AGENT_DATA["description"]
    assert agent.descriptor == AGENT_DATA["descriptor"]
    assert agent.context == AGENT_DATA["context"]
    assert agent.meta == AGENT_DATA["meta"]
    assert agent.published == AGENT_DATA["published"]

def test_update_agent(headers, init_app):
    # TODO: Update test to consider context and meta changes
    AGENT_DATA["name"] = "Updated Name"
    AGENT_DATA["description"] = "Updated Description"
    response = requests.post(
        f"{INSTANCE_URL}/walker/update_agent",
        headers=headers,
        json={
            "agent_name": AGENT_DATA["name"],
            "agent_data": AGENT_DATA
        },
    )
    assert response.status_code == 200
    
    # Assert dataclass matches response
    agent = Agent(**response.json())
    assert agent.id == AGENT_DATA["id"]
    assert agent.name == AGENT_DATA["name"]
    assert agent.description == AGENT_DATA["description"]
    assert agent.descriptor == AGENT_DATA["descriptor"]
    assert agent.context == AGENT_DATA["context"]
    assert agent.meta == AGENT_DATA["meta"]
    assert agent.published == AGENT_DATA["published"]

def test_export_agent(headers, init_app):
    response = requests.post(
        f"{INSTANCE_URL}/walker/export_agent",
        headers=headers,
        json={
            "agent_name": AGENT_DATA["name"]
        },
    )
    assert response.status_code == 200
    assert response.json() == AGENT_DATA

def test_init_agents(headers, init_app):
    response = requests.post(
        f"{INSTANCE_URL}/walker/init_agents",
        headers=headers,
    )
    assert response.status_code == 200

def test_list_agents(headers, init_app):
    response = requests.post(
        f"{INSTANCE_URL}/walker/list_agents",
        headers=headers,
    )
    assert response.status_code == 200
    assert AGENT_DATA["name"] in response.json()

def test_get_agent(headers, init_app):
    response = requests.post(
        f"{INSTANCE_URL}/walker/get_agent",
        headers=headers,
        json={
            "agent_name": AGENT_DATA["name"]
        },
    )
    assert response.status_code == 200
    assert response.json()["name"] == AGENT_DATA["name"]
    assert response.json()["description"] == AGENT_DATA["description"]
    assert response.json()["descriptor"] == AGENT_DATA["descriptor"]
    assert response.json()["context"] == AGENT_DATA["context"]
    assert response.json()["meta"] == AGENT_DATA["meta"]
    assert response.json()["published"] == AGENT_DATA["published"]

def test_delete_agent(headers, init_app):
    response = requests.post(
        f"{INSTANCE_URL}/walker/delete_agent",
        headers=headers,
        json={
            "agent_name": AGENT_DATA["name"]
        },
    )
    assert response.status_code == 200