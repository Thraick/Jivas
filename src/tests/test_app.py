import requests
import pytest
from config import INSTANCE_URL
from test_user import headers

@pytest.fixture
def init_app(headers):
    response = requests.post(
        f"{INSTANCE_URL}/walker/init_app",
        headers=headers,
    )
    assert response.status_code == 200

def test_init_app(headers):
    response = requests.post(
        f"{INSTANCE_URL}/walker/init_app",
        headers=headers,
    )
    assert response.status_code == 200
    assert "agents" in response.json()