#include "../lib/lib.h"

#include <gtest/gtest.h>

// GoogleTest

TEST(google_test_helloworld, google_test_version)
{
	ASSERT_GT(version(), 0) << "version() is not > 0";
}
