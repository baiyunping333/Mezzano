(in-package #:sys.int)

(defconstant +tag-even-fixnum+  #b0000)
(defconstant +tag-cons+         #b0001)
(defconstant +tag-symbol+       #b0010)
(defconstant +tag-array-header+ #b0011)
(defconstant +tag-std-instance+ #b0100)
;;(defconstant +tag-+  #b0101)
;;(defconstant +tag-+  #b0110)
(defconstant +tag-array-like+   #b0111)
(defconstant +tag-odd-fixnum+   #b1000)
;;(defconstant +tag-+  #b1001)
(defconstant +tag-character+    #b1010)
;;(defconstant +tag-+  #b1011)
(defconstant +tag-function+     #b1100)
;;(defconstant +tag-+  #b1101)
(defconstant +tag-unbound-value+  #b1110)
;;(defconstant +tag-+  #b1111)

(defconstant +array-type-t+ 0)
(defconstant +array-type-base-char+ 1)
(defconstant +array-type-character+ 2)
(defconstant +array-type-bit+ 3)
(defconstant +array-type-unsigned-byte-2+ 4)
(defconstant +array-type-unsigned-byte-4+ 5)
(defconstant +array-type-unsigned-byte-8+ 6)
(defconstant +array-type-unsigned-byte-16+ 7)
(defconstant +array-type-unsigned-byte-32+ 8)
(defconstant +array-type-unsigned-byte-64+ 9)
(defconstant +array-type-signed-byte-1+ 10)
(defconstant +array-type-signed-byte-2+ 11)
(defconstant +array-type-signed-byte-4+ 12)
(defconstant +array-type-signed-byte-8+ 13)
(defconstant +array-type-signed-byte-16+ 14)
(defconstant +array-type-signed-byte-32+ 15)
(defconstant +array-type-signed-byte-64+ 16)
(defconstant +array-type-single-float+ 17)
(defconstant +array-type-double-float+ 18)
(defconstant +array-type-long-float+ 19)
(defconstant +array-type-xmm-vector+ 20)
(defconstant +array-type-complex-single-float+ 21)
(defconstant +array-type-complex-double-float+ 22)
(defconstant +array-type-complex-long-float+ 23)
(defconstant +last-array-type+ 23)
(defconstant +array-type-bignum+ 25)
(defconstant +array-type-stack-group+ 30)
(defconstant +array-type-struct+ 31)

(defconstant +function-type-function+ 0)
(defconstant +function-type-closure+ 1)
