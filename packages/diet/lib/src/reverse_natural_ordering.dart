/*
 * Copyright (C) 2007 The Guava Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import 'package:quiver/check.dart';

import 'ordering.dart';

class ReverseNaturalOrdering extends Ordering<Comparable>  {
static final ReverseNaturalOrdering INSTANCE = ReverseNaturalOrdering();

   Ordering<Comparable?>? nullsFirst;
   Ordering<Comparable?>? nullsLast;

@override
 int compareTo( Comparable right) {
//checkNotNull(left); // for GWT
//checkNotNull(right);
return (this).compareTo(right);
}

@override
 Ordering<S?> nullsFirst<S extends Comparable> () {
  Ordering<Comparable?>? result = nullsFirst;
  if (result == null) {
  result = nullsFirst = super.nullsFirst<Comparable>();
  }
  return  result as Ordering<S>;
}

@override
  Ordering<S?> nullsLast<S extends Comparable>() {
  Ordering<Comparable?>? result = nullsLast;
  if (result == null) {
  result = nullsLast = super.nullsLast<Comparable>();
  }
  return  result as Ordering<S>;
}

@override
Ordering<S> reverse <S extends Comparable> () {
  return ReverseNaturalOrdering.INSTANCE (Ordering<S>) ;
}

// preserving singleton-ness gives equals()/hashCode() for free
private Object readResolve() {
  return INSTANCE;
}

@override
 String toString() {
  return "Ordering.natural()";
}

private NaturalOrdering() {}

private static final long serialVersionUID = 0;
}