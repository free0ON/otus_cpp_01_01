#define BOOST_TEST_MODULE boost_test_version

#include "lib.h"

#include <boost/test/unit_test.hpp>

// Boost test

BOOST_AUTO_TEST_SUITE(boost_test)

BOOST_AUTO_TEST_CASE(test_valid_version)
{
    BOOST_CHECK(version() > 0);
}

}
