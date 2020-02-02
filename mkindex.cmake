if(NOT DIGIT)
    message(FATAL_ERROR "??")
endif()

if(NOT INDEX)
    message(FATAL_ERROR "??")
endif()

if(NOT OUT)
    message(FATAL_ERROR "??")
endif()

file(STRINGS ${INDEX} revs REGEX ^${DIGIT})

set(lines)
foreach(r ${revs})
    set(lines "${lines}\n${r}")
endforeach()
set(lines "${lines}\n")

file(WRITE ${OUT} ${lines})
