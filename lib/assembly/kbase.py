import sys
import json

# Usage: typespec_to_assembly_data  typespec_json  >  assembly_data_json

def typespec_to_assembly_data(spec):
    lib_types = dict (
        paired_end_libs = 'paired',
        single_end_libs = 'single',
        references      = 'reference',
    )
    data = {}
    file_sets = []
    for key, val in spec.items():
        lib_type = lib_types.get(key)
        if lib_type == None:
            data[key] = val
        else:
            libs = val if isinstance(val, list) else [ val ]
            for lib in libs:
                file_set = dict((k,v) for k,v in lib.items() if not is_handle(k,v))
                file_set["file_infos"] = list(extract_handle(v) for k,v in lib.items() if is_handle(k,v))
                file_set["type"] = lib_type 
                file_sets.append(file_set)
    data["file_sets"] = file_sets
    return data

def extract_handle(typespec_handle):
    mapping = dict (
        id        = 'shock_id',
        url       = 'shock_url',
        file_name = 'filename',
    )
    mapit = lambda k: mapping[k] if k in mapping else k
    handle = dict((mapit(k), v) for k,v in typespec_handle.items())
    return handle

def is_handle(k, v):
    if k.find("handle") >= 0 and "id" in v:
        return True
    return False
