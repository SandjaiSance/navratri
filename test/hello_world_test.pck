CREATE OR REPLACE PACKAGE hello_world_test AS
    PROCEDURE test_hello_world;
END hello_world_test;
/

CREATE OR REPLACE PACKAGE BODY hello_world_test AS
    PROCEDURE test_hello_world IS
    BEGIN
        ut.expect(1 + 1).to_equal(2);
        ut.expect('Hello, World!').to_equal('Hello, World!');
    END test_hello_world;
END hello_world_test;
/