def change_system(sys_num,number,target_sys_num):
    char_values = {"A":10,"B":11,"C":12,"D":13,"E":14,
    "F":15,"G":16,"H":17,"I":18,"J":19,"K":20,"L":21,
    "M":22,"N":23,"O":24,"P":25,"Q":26,"R":27,"S":28,
    "T":29,"U":30,"V":31}

    if sys_num == target_sys_num:
        return number

    elif sys_num > 32 or sys_num < 2:
        return "The source system must be in the range 2-32"

    elif target_sys_num > 32 or target_sys_num < 2:
        return "The target system must be in the range 2-32"

    else:
        num_length = len(number)

        decimal_res = 0
        for i in range(num_length):
            if number[i].isdigit():
                decimal_res = decimal_res * sys_num + int(number[i])

            elif number[i].capitalize() in char_values:
                decimal_res = decimal_res * sys_num + int(char_values[number[i].capitalize()])

            else:
                return "An invalid number was given."

        if target_sys_num == 10:
            return "Result: " + str(decimal_res)

        else:
            def get_key(val): 
                for key, value in char_values.items(): 
                    if val == value: 
                        return key 
            result = ""
            while True:
                mod = decimal_res % target_sys_num
                if mod > 9:
                    result += str(get_key((mod)))

                else:
                    result += str(mod)
                    
                if decimal_res < target_sys_num:
                    return "Result: " + str(result[::-1])

                decimal_res = int(decimal_res / target_sys_num)
while True:
    print(75*"-")
    print("Conversion of number systems 2-32: ")
    print(75*"-")
    
    try:
        sys_num = int(input("Specify the system (2-32): "))
        number = input("Enter a number: ")
        target_sys_num = int(input("Specify to which system you want to convert(2-32): "))

        print(str(change_system(sys_num,number,target_sys_num)))

        if input("Would you like to continue? Y/N?: ") in ("n","N","no","NO","No","quit","exit"):
            break

    except:
        print("\nAn invalid number system has been specified.")