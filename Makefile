# Project name
EXEC=quasar
TESTEXEC=test-quasar

# Compiler
IDIR=include 
IDIRFLAG=$(foreach idir, $(IDIR), -I$(idir))
CXXFLAGS=-std=c++0x -Ofast -W -Wall -Wextra -pedantic -Wno-sign-compare -Wno-unused-parameter $(IDIRFLAG)

# Linker
LFLAGS=$(IDIRFLAG)

# Directories
TESTDIR=test
SRCDIR=src 
OBJDIR=obj
BINDIR=bin
TESTOBJDIR=testobj

# Files
TESTS=$(foreach sdir, $(TESTDIR), $(wildcard $(sdir)/*.cpp))
SOURCES=$(foreach sdir, $(SRCDIR), $(wildcard $(sdir)/*.cpp))
OBJECTS=$(patsubst %.cpp, $(OBJDIR)/%.o, $(notdir $(SOURCES)))
TESTOBJECTS=$(patsubst %.cpp, $(TESTOBJDIR)/%.o, $(notdir $(TESTS)))

# For rm
TESTTILDE=$(foreach sdir, $(TESTDIR), $(wildcard $(sdir)/*.cpp~))
SOURCESTILDE=$(foreach sdir, $(SRCDIR), $(wildcard $(sdir)/*.cpp~))
INCLUDESTILDE=$(foreach idir, $(IDIR), $(wildcard $(idir)/*.hpp~))

vpath %.cpp $(SRCDIR) $(TESTDIR)

# Reminder, 'cause it is easy to forget makefile's fucked-up syntax...
# $@ is what triggered the rule, ie the target before :
# $^ is the whole dependencies list, ie everything after :
# $< is the first item in the dependencies list

# Rules
gcc: clean
gcc: CXX=g++
gcc: LINKER=g++ -o
gcc: CXXFLAGS += -DNDEBUG
gcc: $(BINDIR)/$(EXEC)

gcc-debug: clean
gcc-debug: CXX=g++
gcc-debug: LINKER=g++ -o
gcc-debug: CXXFLAGS += -g
gcc-debug: $(BINDIR)/$(EXEC)

gcc-test: clean
gcc-test: CXX=g++
gcc-test: LINKER=g++ -l gtest -o
gcc-test: CXXFLAGS += -DNDEBUG
gcc-test: LDFLAGS += -l gtest
gcc-test: $(BINDIR)/$(TESTEXEC)

clang: clean
clang: CXX=clang++
clang: LINKER=clang++ -o
clang: CXXFLAGS += -DNDEBUG -stdlib=libc++
clang: $(BINDIR)/$(EXEC)

clang-debug: clean
clang-debug: CXX=clang++
clang-debug: LINKER=clang++ -o
clang-debug: CXXFLAGS += -g -stdlib=libc++
clang-debug: $(BINDIR)/$(EXEC)

$(BINDIR)/$(EXEC): $(OBJECTS)
	@$(LINKER) $@ $(LFLAGS) $^
	
$(BINDIR)/$(TESTEXEC): $(TESTOBJECTS)
	$(LINKER) $@ $(LFLAGS) $^

$(OBJDIR)/%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@
	
$(TESTOBJDIR)/%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

.PHONY: gcc gcc-debug clang clang-debug clean 

clean:
	rm -fr core *~ $(OBJECTS) $(TESTOBJECTS) $(BINDIR)/$(EXEC) $(BINDIR)/$(TESTEXEC) $(SOURCESTILDE) $(INCLUDESTILDE)

