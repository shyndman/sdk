// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/*element: main:access=*,calls=*,params=0*/
main() {
  method1(new Class1a());
  method2(new Class2a());
  method2(new Class2b());

  method3(new Class3a());
  Class3b b = new Class3b();
  method3(b);
  print(b.field3);

  method5(new Class5a());
  method6(new Class6a());
  method6(new Class6b());
  method7();
  method8();
  method9();
  method10();
}

class Class1a {
  /*element: Class1a.field1:emitted*/
  @pragma('dart2js:noElision')
  int field1;
}

/*element: method1:assign=[field1],params=1*/
@pragma('dart2js:noInline')
method1(Class1a c) {
  c.field1 = 42;
}

class Class2a {
  /*element: Class2a.field2:emitted*/
  @pragma('dart2js:noElision')
  int field2 = 42;
}

class Class2b extends Class2a {}

/*element: method2:assign=[field2],params=1*/
@pragma('dart2js:noInline')
method2(Class2a c) {
  c.field2 = 42;
}

class Class3a {
  /*element: Class3a.field3:elided,set=simple*/
  var field3;
}

class Class3b implements Class3a {
  /*element: Class3b.field3:emitted,set=simple*/
  var field3;
}

/*element: method3:calls=[set$field3(1)],params=1*/
@pragma('dart2js:noInline')
method3(Class3a a) => a.field3 = 42;

class Class5a {
  /*element: Class5a.field5:elided*/
  int field5;
}

/*element: method5:params=1*/
@pragma('dart2js:noInline')
method5(Class5a c) {
  c.field5 = 42;
}

class Class6a {
  /*element: Class6a.field6:elided*/
  int field6 = 42;
}

class Class6b extends Class6a {}

@pragma('dart2js:noInline')
method6(Class6a c) {
  /*element: method6:params=1*/
  c.field6 = 42;
}

/*element: field7:emitted*/
@pragma('dart2js:noElision')
int field7;

/*element: method7:assign=[field7],params=0*/
@pragma('dart2js:noInline')
method7() {
  field7 = 42;
}

int field8;

/*element: method8:params=0*/
@pragma('dart2js:noInline')
method8() {
  field8 = 42;
}

/*element: field9:emitted,lazy*/
@pragma('dart2js:noElision')
int field9 = throw 'field9';

/*element: method9:assign=[field9],params=0*/
@pragma('dart2js:noInline')
method9() {
  field9 = 42;
}

int field10 = throw 'field9';

/*element: method10:params=0*/
@pragma('dart2js:noInline')
method10() {
  field10 = 42;
}
