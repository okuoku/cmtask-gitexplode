if(NOT INDEX)
    message(FATAL_ERROR "??")
endif()

if(NOT OUTDIR)
    message(FATAL_ERROR "??")
endif()

if(NOT REPO)
    message(FATAL_ERROR "??")
endif()

function(rev_to_outdir out rev)
    if(${rev} MATCHES "(..)(..)(.+)")
        set(r "${CMAKE_MATCH_1}/${CMAKE_MATCH_2}")
    else()
        message(FATAL_ERROR "Invalid rev format ${rev}")
    endif()
    set(${out} "${r}" PARENT_SCOPE)
endfunction()

file(STRINGS ${INDEX} revs)

foreach(r ${revs})
    rev_to_outdir(out ${r})
    set(dir ${OUTDIR}/${out})
    set(outfile ${dir}/${r}.diff)

    file(MAKE_DIRECTORY ${dir})
    execute_process(
        COMMAND git show --pretty=fuller -p --no-abbrev -w ${r}
        OUTPUT_FILE ${outfile}
        WORKING_DIRECTORY ${REPO}
        RESULT_VARIABLE rr
        )
    if(rr)
        message(FATAL_ERROR "Failed ${r}: ${rr}")
    endif()
endforeach()
