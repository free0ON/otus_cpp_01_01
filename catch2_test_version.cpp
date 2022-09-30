#include "lib.h"

#include <catch2/catch_test_macros.hpp>

// Catch2 test

TEST_CASE("Patch version control", "[version]") {
	REQUIRE(version() > 0);
}
