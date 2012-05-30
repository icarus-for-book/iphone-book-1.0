//
//  Shader.fsh
//  OpenGLTemplate
//
//  Created by parkinhye on 12. 1. 8..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
