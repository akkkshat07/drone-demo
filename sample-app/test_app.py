from app import hello_world, add_numbers

def test_hello_world():
    assert hello_world() == "Hello from Drone CI!"

def test_add_numbers():
    assert add_numbers(2, 3) == 5
    assert add_numbers(-1, 1) == 0

if __name__ == "__main__":
    test_hello_world()
    test_add_numbers()
    print("All tests passed!")