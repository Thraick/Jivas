import pytest
import requests
from config import (
    INSTANCE_URL, 
    TEST_USER_EMAIL, 
    TEST_USER_PASSWORD
)

@pytest.fixture
def headers():
    response = requests.post(
        f"{INSTANCE_URL}/user/login",
        json={"email": TEST_USER_EMAIL, "password": TEST_USER_PASSWORD},
    )

    if response.status_code != 200:
        # Try registering the user if login fails
        response = requests.post(
            f"{INSTANCE_URL}/user/register",
            json={
                "email": TEST_USER_EMAIL,
                "password": TEST_USER_PASSWORD,
            },
        )
        assert response.status_code == 201
        
        response = requests.post(
            f"{INSTANCE_URL}/user/login",
            json={"email": TEST_USER_EMAIL, "password": TEST_USER_PASSWORD},
        )
        assert response.status_code == 200
    return {"Authorization": f"Bearer {response.json()['token']}"}

@pytest.mark.order(1)
def test_create_user():
    response = requests.post(
        f"{INSTANCE_URL}/user/register",
        json={
            "email": TEST_USER_EMAIL,
            "password": TEST_USER_PASSWORD,
        },
    )
    print(response.json())
    assert response.json() == {"message": "Successfully Registered!"}
    assert response.status_code == 201

@pytest.mark.order(2)
def test_login_user():
    response = requests.post(
        f"{INSTANCE_URL}/user/login",
        json={"email": TEST_USER_EMAIL, "password": TEST_USER_PASSWORD},
    )
    assert response.status_code == 200
    assert "token" in response.json()
