cmake_minimum_required(VERSION 3.0)
project(git-explode NONE)

set(resultdir ${CMAKE_CURRENT_BINARY_DIR}/result)
#get_filename_component(repopath ${CMTASK_GITEXPLODE_REPO} ABSOLUTE)
set(repopath ${CMTASK_GITEXPLODE_REPO})

function(rev_to_basename out rev)
    if(${rev} MATCHES "(..)(..)(.+)")
        set(r "${CMAKE_MATCH_1}/${CMAKE_MATCH_2}/${CMAKE_MATCH_3}")
    else()
        message(FATAL_ERROR "Invalid rev format ${rev}")
    endif()
    set(${out} "${r}" PARENT_SCOPE)
endfunction()

if(NOT CMTASK_GITEXPLODE_REPO)
    message(FATAL_ERROR "??")
endif()

# Get revision list
message(STATUS "Generate rev list...")
execute_process(
    COMMAND git rev-list HEAD
    OUTPUT_FILE ${CMAKE_CURRENT_BINARY_DIR}/revs.txt
    WORKING_DIRECTORY ${repopath}
    )

message(STATUS "Generaing diff targets...")
set(digits 0 1 2 3 4 5 6 7 8 9 a b c d e f)
foreach(c ${digits})
    foreach(b ${digits})
        foreach(a ${digits})
            set(s ${c}${b}${a})
            set(d ${c}${b})
            set(indexfile ${resultdir}/${d}/index.${a}.txt)
            file(MAKE_DIRECTORY ${resultdir}/${d})
            add_custom_command(
                OUTPUT ${indexfile}
                COMMAND ${CMAKE_COMMAND}
                -DDIGIT=${c}${b}${a}
                -DOUT=${indexfile}
                -DINDEX=${CMAKE_CURRENT_BINARY_DIR}/revs.txt
                -P ${CMAKE_CURRENT_LIST_DIR}/mkindex.cmake)
            add_custom_target(rev_${s} ALL
                COMMAND ${CMAKE_COMMAND}
                -DINDEX=${indexfile}
                -DOUTDIR=${resultdir}
                -DREPO=${repopath}
                -P ${CMAKE_CURRENT_LIST_DIR}/mkdiffs.cmake
                COMMENT "Git explode ${d}"
                DEPENDS ${indexfile})
        endforeach()
    endforeach()
endforeach()

message(STATUS "Finish.")
