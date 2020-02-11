import pytest

import pyb.hello_world


@pytest.mark.parametrize("name", ["Foo", "Bar"])
def test_hello_world(name):
    assert pyb.hello_world.greeting(name) == f"Hello {name}"
