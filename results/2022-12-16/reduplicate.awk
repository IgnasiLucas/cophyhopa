{
   if ($1 ~ /^@|size=1$/) {
      print $0
   } else {
      split($1, A, /[;=]/)
      for (i = 1; i <= A[3]; i++) {
         $1 = A[1] ";copy=" i
         print $0
      }
   }
}
