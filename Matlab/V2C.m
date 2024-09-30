% 将向量转化为列向量

function column = V2C( vector )

    %% dbstop if  error ;
%     if ~isvector( vector ) && ~ isscalar( vector ) && ~isempty( vector )
    if  isscalar( vector ) 
        column = vector ;
    elseif ~isvector( vector ) && ~ isscalar( vector ) && ~isempty( vector )
        error( 'not vector!!' )
    else
        column = vector ;
        if isrow(column )
           column = column' ;
        end
    end

end