load transition_vwnd_NDJFM_lev250_lat0-90_lon20-130_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1
%normalization for each column;
each_col_t=repmat(sum(pattern_transition,1),[1,size(pattern_transition,2)]);
pattern_transition_normalized=pattern_transition./each_col_t;%normalized

save('transition_vwnd_NDJFM_lev250_lat0-90_lon20-130_year1979-2010_filter-deseasonal3-highpassNwgt31-0.1','pattern_transition_normalized','-append');

