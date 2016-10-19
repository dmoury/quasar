#include "gtest/gtest.h"

int doubleInt (int i) {
  return 2 * i;
}

TEST (SquareRootTest, PositiveNos) { 
  EXPECT_EQ (18, doubleInt(9));
}


int main(int argc, char **argv) {
  ::testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
