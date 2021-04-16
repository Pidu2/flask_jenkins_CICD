from hello_world import randy
from hello_world import app


# unit
def test_random():
    """
    GIVEN two integers
    WHEN a random number is needed between these
    THEN check that the random number lies in the expected range
    """
    for _ in range(0, 10):
        a = randy(0, 10)
        assert a <= 10 and a >= 0


# functional
def test_root():
    """
    GIVEN the application
    WHEN the root is requested (GET)
    THEN check the return code and content
    """
    with app.test_client() as test_client:
        response = test_client.get('/')
        assert response.status_code == 200
        assert b"Hello World!" in response.data


def test_cc():
    """
    GIVEN the /cc endpoint
    WHEN it is requested
    THEN check that the returned number is correct
    """
    import random
    for _ in range(0, 10):
        nbr = random.randint(1, 100)
        txt = "a"*nbr
        with app.test_client() as test_client:
            response = test_client.get('/cc/'+txt)
            assert response.status_code == 200
            assert nbr == int(response.data.decode('utf-8').split(' ')[0])
