#include <zpp_throwing.h>
#include <print>

zpp::throwing<int> foo(bool success)
{
    if (!success) {
        // Throws an exception.
        co_yield std::runtime_error("My runtime error");
    }

    // Returns a value.
    co_return 1337;
}

int main()
{
    return zpp::try_catch([]() -> zpp::throwing<int> {
        std::println("Hello World!");
        std::println("{}", co_await foo(false));
        co_return 0;
    }, [&](const std::exception& error) {
        std::println("std exception caught: {}", error.what());
        return 1;
    }, [&]() {
        std::println("Unknown exception");
        return 1;
    });
}