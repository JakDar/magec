{
    nonalpha=length(gensub("[[:alpha:]]","","g",$0));
    if (length >0 && nonalpha/length > 0.6) {

    } else {
        print
    }

}
