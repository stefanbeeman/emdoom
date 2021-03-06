cdef public void __faketypes__():
  pass

def to_fixed(number):
  return int(number * float(2 ** 16))

def from_fixed(number):
  return number/float(2 ** 16)

def to_fixed_angle(angle):
  return int(angle * float(2 ** 32))/360

def from_fixed_angle(angle):
  return (angle/float(2 ** 32)) * 360

cdef FName to_fname(name):
  cdef char* encoded = <char*>name
  return FName(encoded)

cdef object from_fname(FName fname):
  return str(fname.GetChars())

cdef FString to_fstring(value):
  cdef char* encoded = <char*>value
  return FString(encoded)

cdef object from_fstring(FString value):
  return str(value.GetChars())
