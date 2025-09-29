def hello_world():
    return "Hello from Drone CI!"

def add_numbers(a, b):
    return a + b

if __name__ == "__main__":
    print(hello_world())
    print(f"2 + 3 = {add_numbers(2, 3)}")