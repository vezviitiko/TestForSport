def MyFuncDevisionObj(dev_obj, dev):

    size_dev_obj = len(dev_obj)

    if dev <= 0 or not dev_obj or size_dev_obj <= dev:
        return []

    size_new_obj = size_dev_obj // dev
    count_first_big_obj = size_dev_obj % dev

    result = []
    tmp_part = []
    for i in dev_obj:
        if count_first_big_obj:
            if len(tmp_part) == size_new_obj+1:
                result.append(tmp_part)
                tmp_part = []
                count_first_big_obj -=1
        elif len(tmp_part) == size_new_obj:
                result.append(tmp_part)
                tmp_part = []

        tmp_part.append(i)

    result.append(tmp_part)

    return result

print(MyFuncDevisionObj([[1,'a','b'], [2, 'c', 'd'], [3, 'e', 'f']], 2))
print(MyFuncDevisionObj([1,2,3,4,5,6,7,8,9], 4))
print(MyFuncDevisionObj([1,2,3,4,5,6,7,8,9,10], 4))
