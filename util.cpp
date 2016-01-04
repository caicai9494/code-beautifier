#include "util.h"

#include <string>
#include <cctype>
#include <algorithm>

void toupper(char* to, const char* from)
{
    std::string fromc(from);
    std::string toc;
    std::transform(fromc.begin(), 
		   fromc.end(),
		   toc.begin(),
		   ::toupper); 

    to = strdup(toc.c_str());
}
