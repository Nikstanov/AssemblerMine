format  PE GUI 5.0
entry   WinMain


;=================================Include=======================================

        include         "win32a.inc"
        include         "api\kernel32.inc"
        include         "api\user32.inc"
        include         "api\gdi32.inc"
        include         "opengl.inc"
        
        
        data import

        library kernel32,       "KERNEL32.DLL",\
                user32,         "USER32.DLL",\
                gdi32,          "GDI32.DLL",\
                opengl32,       "OPENGL32.DLL",\
                glfw32,         "GLFW32.DLL";,\
;                winmm,          "WINMM.DLL"

;        import winmm,\
;                PlaySound,'PlaySoundA'

        end data
        
;=================================Struct========================================
        include         "Kripe.inc"
                
struct Vertex
        x       dd      ?
        y       dd      ?
        z       dd      ?
ends

struct Color
        r       dd      ?
        g       dd      ?
        b       dd      ?
ends

struct Mesh
        vertices        dd      ?
        colors          dd      ?
        normals         dd      ?
        verticesCount   dd      ?
ends

struct PackedMesh
        vertices        dd      ?
        colors          dd      ?
        indices         dd      ?
        trianglesCount  dd      ?
ends

struct Vector4
        x       GLfloat         ?
        y       GLfloat         ?
        z       GLfloat         ?
        w       GLfloat         ?
ends

struct ColorRGBA
        r       GLfloat         ?
        g       GLfloat         ?
        b       GLfloat         ?
        a       GLfloat         ?
ends        

struct Vector3
        x       dd      ?
        y       dd      ?
        z       dd      ?
ends

struct Coordinate
        x       db      ?
        y       db      ?
        z       db      ?
ends

struct Matrix4x4
        m11     dd      ?
        m12     dd      ?
        m13     dd      ?
        m14     dd      ?
        m21     dd      ?
        m22     dd      ?
        m23     dd      ?
        m24     dd      ?
        m31     dd      ?
        m32     dd      ?
        m33     dd      ?
        m34     dd      ?
        m41     dd      ?
        m42     dd      ?
        m43     dd      ?
        m44     dd      ?
ends


;=================================Macro=========================================

macro JumpIf value, label
{
        cmp     eax, value
        je      label
}


;=================================Vars==========================================


defCubeVertices           dd      0.0, 0.0, 0.5,\
                                  0.0, 0.5, 0.5,\
                                  0.5, 0.0, 0.5,\
                                  0.5, 0.5, 0.5,\
                                  0.5, 0.0, 0.0,\
                                  0.5, 0.5, 0.0,\
                                  0.0, 0.0, 0.0,\
                                  0.0, 0.5, 0.0

cubeVertices              dd      0.0, 0.0, 0.5,\
                                  0.0, 0.5, 0.5,\
                                  0.5, 0.0, 0.5,\
                                  0.5, 0.5, 0.5,\
                                  0.5, 0.0, 0.0,\
                                  0.5, 0.5, 0.0,\
                                  0.0, 0.0, 0.0,\
                                  0.0, 0.5, 0.0

cubeIndices     db      2, 3, 1,\
                        2, 1, 0,\
                        4, 5, 3,\
                        4, 3, 2,\
                        6, 7, 5,\
                        6, 5, 4,\
                        0, 1, 7,\
                        0, 7, 6,\
                        3, 5, 7,\
                        3, 7, 1,\
                        4, 2, 0,\
                        4, 0, 6

cubeColors      dd      0.0, 0.31, 0.0,\
                        0.0, 0.31, 0.0,\
                        0.0, 0.31, 0.0,\
                        0.0, 0.31, 0.0,\
                        0.0, 0.31, 0.0,\
                        0.0, 0.31, 0.0,\
                        0.0, 0.31, 0.0,\
                        0.0, 0.31, 0.0

worldWidth      db      50 ;coor - y
worldLen        db      30 ;coor - x
worldHeight     db      20 ;coor - z

; 1 - зеленый (земля)
; 2 - темно-синий (камень)
; 3 - коричневый (дерево)
; 4 - светло-зеленый (листья)                        
cubeArray       dd        ?
;cubeArray        db      10 dup 2, 10 dup 1, 80 dup 0,\
;                         10 dup 2, 10 dup 1, 80 dup 0,\
;                         10 dup 2, 10 dup 1, 80 dup 0,\ 
;                        10 dup 2, 10 dup 1, 80 dup 0,\
;                        10 dup 2, 10 dup 1, 80 dup 0,\
;                        10 dup 2, 10 dup 1, 80 dup 0,\
;                        10 dup 2, 10 dup 1, 80 dup 0,\
;                        10 dup 2, 10 dup 1, 80 dup 0,\
;                        10 dup 2, 10 dup 1, 80 dup 0,\
;                        10 dup 2, 10 dup 1, 80 dup 0
                      
blockSize     dd          0.5
personSize    dd          0.9

focusBlock    dd          ?
newBlock      dd          ?
    

        ;-----------------Colors---------------------------               
;clRed           Color   1.0,  0.0 , 0.0
;clGreen         Color   0.0,  0.31, 0.0
;clLightGreen    Color   0.0,  0.78, 0.0
;clBrown         Color   0.4,  0.2 , 0.0 
;clGrey          Color   0.38, 0.38, 0.38
;clBackground    Color   0.14, 0.43, 0.86

        colors          dd        0.0,  0.31, 0.0 ,\
                                  0.38, 0.38, 0.38,\
                                  0.4,  0.2 , 0.0 ,\
                                  0.0,  0.78, 0.0 ,\
                                  0.7,  0.0 , 0.0 ,\
                                  0.1,  0.1,  0.1 ,\
                                  0.0,  0.0,  0.7 ,\
                                  0.8,  0.8,  0.0 
                                   
        focusType       db        3                          
        colorMenu       db        0
        moveMode        db        0
        lastPos         POINT     

        cubeMesh           PackedMesh    cubeVertices, cubeColors, cubeIndices, CUBE_TRIANGLES_COUNT
        KriperMesh5      PackedMesh    KriperVertices5, kriperColors5, kriperIndices5, KRIPERFACE1_TRIANGLES_COUNT
        KriperMesh4      PackedMesh    KriperVertices4, kriperColors4, kriperIndices4, KRIPERFACE_TRIANGLES_COUNT 
        KriperMesh3      PackedMesh    KriperVertices3, kriperColors, kriperIndices03, CUBE_TRIANGLES_COUNT
        KriperMesh2      PackedMesh    KriperVertices2, kriperColors, kriperIndices03, CUBE_TRIANGLES_COUNT
        KriperMesh1      PackedMesh    KriperVertices1, kriperColors, kriperIndices03, CUBE_TRIANGLES_COUNT
        KriperMesh0      PackedMesh    KriperVertices0, kriperColors, kriperIndices03, CUBE_TRIANGLES_COUNT
           
        mesh            Mesh    ?, ?, ?, ?
        mesh1            Mesh    ?, ?, ?, ?
        mesh2            Mesh    ?, ?, ?, ?    
        
        fovY            dd      90.0
        zNear           dd      0.001
        zFar            dd      100.0
        
        ;------------------Camera-------------------------

        cameraPosition  Vector3 0.5, 2.3, 0.5
        targetPosition  Vector3 -5.0, 3.0, 5.0
        upVector        Vector3 0.0, 1.0, 0.0
        cameraFront     Vector3 -5.0, 3.0, -5.0
        
        
        time            dd      ?
        oneSecond       dd      1000.0
        incTime         dd      ?
;-------------------------------------------------------------------------------

        
        pressedKeys     db      0,0,0,0
        yaw             dd      -90.0
        pitch           dd      90.0
        lastX           dw      ?
        lastY           dw      ?
        centerX         dd      ?
        centerY         dd      ?
        
        hMainWindow     dd              ?
        
        className       db      "Minecraft2", 0
        clientRect      RECT
        hHeap           dd      ?
        hdcBack         dd      ?
        hdc             dd      ?
        radian          dd      57.32
        firstMouse      dd      1
        
        fileName        db      "Save0",0
;        music           db      "calm1.wav",0

;===================================Const=======================================

        CUBE_TRIANGLES_COUNT    =       6 * 2
        ;CUBE_VERTICES_COUNT     =       CUBE_TRIANGLES_COUNT * 3
        
        true            =       1
        false           =       0

        COLOR_DEPTH     =       24
        PFD_FLAGS       =       PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER or PFD_DRAW_TO_WINDOW
        WINDOW_STYLE    =       WS_VISIBLE or WS_MAXIMIZE or WS_POPUP
       
        wndClass        WNDCLASS                0, WindowProc, 0, 0, 0, 0, 0, 0, 0, className
        pfd             PIXELFORMATDESCRIPTOR   sizeof.PIXELFORMATDESCRIPTOR, 1, PFD_FLAGS, PFD_TYPE_RGBA, COLOR_DEPTH,\
                                                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,\
                                                COLOR_DEPTH, 0, 0, PFD_MAIN_PLANE, 0, PFD_MAIN_PLANE
                                                
;==================================proc========================================+

proc Init uses esi

        locals
                
                aspect          dd              ?
        endl

        invoke  GetProcessHeap
        mov     [hHeap], eax
        invoke  RegisterClass, wndClass
        invoke  CreateWindowEx, ebx, className, className, WINDOW_STYLE,\
                        ebx, ebx, ebx, ebx, ebx, ebx, ebx, ebx
        mov     [hMainWindow], eax
        invoke  GetClientRect, eax, clientRect
        
        
        invoke  ShowCursor, ebx
        invoke  GetTickCount
        mov     [time], eax

        invoke  GetDC, [hMainWindow]
        mov     [hdc], eax

        invoke  ChoosePixelFormat, [hdc], pfd
        invoke  SetPixelFormat, [hdc], eax, pfd

        invoke  wglCreateContext, [hdc]
        invoke  wglMakeCurrent, [hdc], eax

        invoke  glViewport, ebx, ebx, [clientRect.right], [clientRect.bottom]

        fild    [clientRect.right]      ; width
        fidiv   [clientRect.bottom]     ; width / height
        fstp    [aspect]                ;
        
        mov     eax,[clientRect.right]
        shr     eax,1
        mov     [centerX],eax 
        mov     eax,[clientRect.bottom]
        shr     eax,1
        mov     [centerY],eax
        invoke  SetCursorPos,[centerX],[centerY]

        invoke  glMatrixMode, GL_PROJECTION
        invoke  glLoadIdentity

        stdcall Matrix.Projection, [aspect], [fovY], [zNear], [zFar]

        invoke  glEnable, GL_DEPTH_TEST
        invoke  glShadeModel, GL_SMOOTH
        invoke  glHint, GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST 
         
;        invoke PlaySound,music,NULL,1
        
        stdcall GenerateMesh, cubeMesh, mesh, true
        stdcall GenerateMesh, KriperMesh4, mesh1, true
        stdcall GenerateMesh, KriperMesh5, mesh2, true
        stdcall GenerateWorld
        
        ret
endp

proc DrawMesh uses esi,\
     mesh
        locals
            black   dd   0.0
        endl
        
        mov     esi, [mesh]
        invoke  glEnableClientState, GL_VERTEX_ARRAY
        invoke  glEnableClientState, GL_COLOR_ARRAY
        invoke  glEnableClientState, GL_NORMAL_ARRAY

        invoke  glVertexPointer, 3, GL_FLOAT, ebx, [esi + Mesh.vertices]
        invoke  glColorPointer, 3, GL_FLOAT, ebx, [esi + Mesh.colors]
        invoke  glNormalPointer, GL_FLOAT, ebx, [esi + Mesh.normals]
        invoke  glDrawArrays, GL_TRIANGLES, ebx, [esi + Mesh.verticesCount]

        
        
;        invoke glPolygonMode,GL_FRONT_AND_BACK, GL_LINE
;        
;        mov   edi,[esi + Mesh.colors]   
;        mov   eax,[black]
;        mov   ecx,72
;@@:
;        mov   [edi],eax
;        add   edi,4
;        loop @b
;        
;        mov     esi, [mesh]
;        invoke  glVertexPointer, 3, GL_FLOAT, ebx, [esi + Mesh.vertices]
;        invoke  glColorPointer, 3, GL_FLOAT, ebx, [esi + Mesh.colors]
;        invoke  glNormalPointer, GL_FLOAT, ebx, [esi + Mesh.normals]
;        invoke  glDrawArrays, GL_TRIANGLES, ebx, [esi + Mesh.verticesCount]
;        
;        invoke glPolygonMode,GL_FRONT_AND_BACK, GL_FILL
;        
;        
 ;   
        invoke  glDisableClientState, GL_VERTEX_ARRAY
        invoke  glDisableClientState, GL_COLOR_ARRAY
        invoke  glDisableClientState, GL_NORMAL_ARRAY
        
        ret
endp


proc GenerateMesh uses ebx esi edi,\
     sourceMesh, resultMesh, copyColors

        locals
                verticesCount   dd      ?
                resultIndex     dd      ?
                vertices        dd      ?
                resultVertices  dd      ?
                colors          dd      ?
                resultColors    dd      ?
                indices         dd      ?
        endl

        mov     [resultIndex], ebx

        mov     esi, [sourceMesh]
        mov     edi, [resultMesh]

        mov     eax, [esi + PackedMesh.trianglesCount]
        xor     edx, edx
        mov     ecx, 3
        mul     ecx
        mov     [verticesCount], eax    ; verticesCount = trianglesCount * 3
        mov     [edi + Mesh.verticesCount], eax
        xor     edx, edx
        mov     ecx, sizeof.Vertex
        mul     ecx
        push    eax
        push    eax
        push    eax
        invoke  HeapAlloc, [hHeap], 8   ; eax
        mov     [resultVertices], eax
        mov     [edi + Mesh.vertices], eax
        invoke  HeapAlloc, [hHeap], 8   ; eax
        mov     [resultColors], eax
        mov     [edi + Mesh.colors], eax
        invoke  HeapAlloc, [hHeap], 8
        mov     [edi + Mesh.normals],eax
 
        ret
endp
 
proc RenewMesh uses ebx esi edi,\
     sourceMesh, resultMesh, focus
     
        locals
                verticesCount   dd      ?
                resultIndex     dd      ?
                vertices        dd      ?
                resultVertices  dd      ?
                colors          dd      ?
                resultColors    dd      ?
                indices         dd      ?
                focusColor      dd      0.1
        endl

        xor     ebx,ebx
        mov     [resultIndex], ebx

        mov     esi, [sourceMesh]
        mov     edi, [resultMesh]

        mov     eax, [edi + Mesh.verticesCount]
        mov     [verticesCount], eax    ; verticesCount = trianglesCount * 3
        mov     eax,[edi + Mesh.vertices]
        mov     [resultVertices], eax
        mov     eax, [edi + Mesh.colors] 
        mov     [resultColors], eax
        

        mov     eax, [esi + PackedMesh.vertices]
        mov     [vertices], eax
        mov     eax, [esi + PackedMesh.colors]
        mov     [colors], eax
        mov     eax, [esi + PackedMesh.indices]
        mov     [indices], eax

        mov     ecx, [verticesCount]
.CopyCycle:
        push    ecx

        xor     edx, edx
        mov     esi, [indices]
        movzx   eax, byte[esi + ebx]    ; index
        mov     edi, sizeof.Vertex
        mul     edi                     ; index * sizeof.Vertex

        mov     esi, [vertices]
        add     esi, eax                ; vertices + index * sizeof.Vertex = vertices[index]

        xor     edx, edx
        mov     eax, [resultIndex]      ; resultIndex
        mov     edi, sizeof.Vertex
        mul     edi                     ; resultIndex * sizeof.Vertex

        mov     edi, [resultVertices]
        add     edi, eax                ; resultVertices + resultIndex * sizeof.Vertex = resultVertices[resultIndex]

        mov     eax, [esi + Vertex.x]   ; x = vertices[index].x
        mov     ecx, [esi + Vertex.y]   ; y = vertices[index].y
        mov     edx, [esi + Vertex.z]   ; z = vertices[index].z
        mov     [edi + Vertex.x], eax   ; resultVertices[resultIndex].x = x
        mov     [edi + Vertex.y], ecx   ; resultVertices[resultIndex].y = y
        mov     [edi + Vertex.z], edx   ; resultVertices[resultIndex].z = z

        xor     edx, edx
        mov     esi, [indices]
        movzx   eax, byte[esi + ebx]    ; index
        mov     edi, sizeof.Color
        mul     edi                     ; index * sizeof.Color

        mov     esi, [colors]
        add     esi, eax                ; colors + index * sizeof.Color = colors[index]

        xor     edx, edx
        mov     eax, [resultIndex]      ; resultIndex
        mov     edi, sizeof.Color
        mul     edi                     ; resultIndex * sizeof.Color

        mov     edi, [resultColors]
        add     edi, eax                ; resultColors + resultIndex * sizeof.Color = resultColors[resultIndex]
        
        cmp     [focus], false
        jz      @f
        
        fld     [esi + Color.r]
        fsub    [focusColor]
        fstp    [edi + Color.r]
        
        fld     [esi + Color.g]
        fsub    [focusColor]
        fstp    [edi + Color.g]
        
        fld     [esi + Color.b]
        fsub    [focusColor]
        fstp    [edi + Color.b]
        
        jmp     .skip
        
        @@:
        mov     eax, [esi + Color.r]    ; r = colors[index].r
        mov     ecx, [esi + Color.g]    ; g = colors[index].g
        mov     edx, [esi + Color.b]    ; b = colors[index].b
        
        mov     [edi + Color.r], eax    ; resultColors[resultIndex].r = r
        mov     [edi + Color.g], ecx    ; resultColors[resultIndex].g = g
        mov     [edi + Color.b], edx    ; resultColors[resultIndex].b = b
        
        .skip:

        inc     ebx
        inc     [resultIndex]

        pop     ecx
        dec     ecx
        cmp     ecx,0
        jnz    .CopyCycle

        ret
endp

proc Vector3.Normalize uses edi,\
     vector

        locals
                l       dd      ?
        endl

        mov     edi, [vector]

        stdcall Vector3.Length, [vector]
        mov     [l], eax

        fld     [edi + Vector3.x]
        fdiv    [l]
        fstp    [edi + Vector3.x]

        fld     [edi + Vector3.y]
        fdiv    [l]
        fstp    [edi + Vector3.y]

        fld     [edi + Vector3.z]
        fdiv    [l]
        fstp    [edi + Vector3.z]

        ret
endp

proc Vector3.Cross uses esi edi ebx,\
     v1, v2, result

        locals
                temp    dd      ?
        endl

        mov     esi, [v1]
        mov     edi, [v2]
        mov     ebx, [result]

        fld     [esi + Vector3.z]
        fmul    [edi + Vector3.y]
        fstp    [temp]
        fld     [esi + Vector3.y]
        fmul    [edi + Vector3.z]
        fsub    [temp]
        fstp    [ebx + Vector3.x]

        fld     [esi + Vector3.x]
        fmul    [edi + Vector3.z]
        fstp    [temp]
        fld     [esi + Vector3.z]
        fmul    [edi + Vector3.x]
        fsub    [temp]
        fstp    [ebx + Vector3.y]

        fld     [esi + Vector3.y]
        fmul    [edi + Vector3.x]
        fstp    [temp]
        fld     [esi + Vector3.x]
        fmul    [edi + Vector3.y]
        fsub    [temp]
        fstp    [ebx + Vector3.z]

        ret
endp

proc Matrix.Projection uses edi,\
     aspect, fov, zNear, zFar

        locals
                matrix          Matrix4x4
                sine            dd              ?
                cotangent       dd              ?
                deltaZ          dd              ?
                radians         dd              ?
        endl

        lea     edi, [matrix]
        mov     ecx, 4 * 4
        xor     eax, eax
        rep     stosd

        lea     edi, [matrix]

        fld     [fov]
        fld1
        fld1
        faddp
        fdivp
        fdiv    [radian]
        fstp    [radians]

        fld     [zFar]
        fsub    [zNear]
        fstp    [deltaZ]

        fld     [radians]
        fsin
        fstp    [sine]

        fld     [radians]
        fcos
        fdiv    [sine]
        fstp    [cotangent]

        fld     [cotangent]
        fdiv    [aspect]
        fstp    [edi + Matrix4x4.m11]

        fld     [cotangent]
        fstp    [edi + Matrix4x4.m22]

        fld     [zFar]
        fadd    [zNear]
        fdiv    [deltaZ]
        fchs
        fstp    [edi + Matrix4x4.m33]

        fld1
        fchs
        fstp    [edi + Matrix4x4.m34]

        fld1
        fld1
        faddp
        fchs
        fmul    [zNear]
        fmul    [zFar]
        fdiv    [deltaZ]
        fstp    [edi + Matrix4x4.m43]

        invoke  glMultMatrixf, edi

        ret
endp


proc WinMain

        locals
                msg     MSG
        endl

        xor     ebx, ebx

        stdcall Init

        lea     esi, [msg]

.cycle:
        invoke  GetMessage, esi, ebx, ebx, ebx
        invoke  TranslateMessage, esi
        invoke  DispatchMessage, esi
        jmp     .cycle

endp

proc WindowProc uses ebx,\
     hWnd, uMsg, wParam, lParam
     
        locals
          Xset        dw        ?
          Yset        dw        ?
          sensivity   dd        0.005
          tmp1        dd        ?
          maxPitch    dd        89.0
          minPitch    dd        -89.0
          tmpCord     Coordinate  ?,?,?
          jump        dd        3.5
        endl  
        
        xor     ebx, ebx

        mov     eax, [uMsg]
        JumpIf  WM_PAINT,       .Paint
        JumpIf  WM_DESTROY,     .Destroy
        JumpIf  WM_KEYDOWN,     .KeyDown
        JumpIf  WM_KEYUP,       .KeyUp
        cmp     [colorMenu],1
        jz     @f
        JumpIf  WM_MOUSEMOVE,   .Mouse
        JumpIf  WM_RBUTTONDOWN, .RightButton
        JumpIf  WM_LBUTTONDOWN, .LeftButton
        @@:     
        
        
        invoke  DefWindowProc, [hWnd], [uMsg], [wParam], [lParam]
        jmp     .Return      
.RightButton:
        stdcall FindFocusBlock
        mov     esi,[focusBlock]
        cmp     esi,0
        jz      @f
        mov     byte [esi],0
        @@:        
        jmp     .ReturnZero
        
.LeftButton:
        stdcall FindFocusBlock
        mov     edi,[focusBlock]
        cmp     edi,0
        jz      .skip
        lea     esi,[cameraPosition]
        lea     edi,[tmpCord]
        stdcall TakeBlock,esi,edi
        stdcall getBlockType,edi
        mov     edi,[newBlock]
        cmp     esi,edi
        jz      .skip
        mov     al,[focusType]  
        mov     byte [edi],al
        .skip:
        
        jmp     .ReturnZero        
.Mouse:

        cmp     [firstMouse],1
        jnz     @f
        mov     ax,word [lParam]
        mov     [lastX],ax
        mov     ax,word [lParam + 2]
        mov     [lastY],ax
        mov     [firstMouse],0
        jmp     .Paint
        
@@:       
        mov     ax,word [lParam]
        mov     dx,ax
        sub     dx,[lastX]
        mov     [Xset],dx
        fild    [Xset]
        fmul    [sensivity]
        fadd    [yaw]        
        fstp    [yaw]          
        mov     [lastX],ax
        
        mov     ax,word [lParam + 2]
        mov     dx,[lastY]
        sub     dx,ax
        mov     [Yset],dx
        fild    [Yset]
        fmul    [sensivity]
        fadd    [pitch]
        mov     [lastY],ax 
        
        fld     [maxPitch]
        fcomip  st0,st1
        jae      @f
        fstp    [pitch]
        fld     [maxPitch]
@@:        
        fstp    [pitch]
        
;        fld     [pitch]  
;        fld     [minPitch]
;       	fchs
;        fcomip  st0,st1
;        jb      @f
;        fstp    [pitch]
;        fld     [minPitch]
;@@:        
;        fstp    [pitch]
        
         
        
        fld     [pitch]
        fsin
        fstp    [cameraFront.y]
       
        fld     [pitch]
        fcos
        fstp    [tmp1]
        fld     [yaw]
        fcos
        fmul    [tmp1]
        fstp    [cameraFront.x]
        
        fld     [pitch]
        fcos
        fstp    [tmp1]
        fld     [yaw]
        fsin
        fmul    [tmp1]
        fstp    [cameraFront.z]
        
        lea     eax,[cameraFront]
        stdcall Vector3.Normalize, eax  
        invoke  SetCursorPos,[centerX],[centerY]
        mov     [firstMouse],1
                 
.Paint:
        stdcall Draw
        jmp     .ReturnZero
.KeyDown:
        cmp     [wParam], VK_F5
        jne     @f
        stdcall File.SaveContent,fileName
        
        jmp     .ReturnZero
@@: 

        cmp     [wParam], VK_F11
        jne     @f
        stdcall File.LoadContent,fileName
        
        jmp     .ReturnZero
@@:
    
        cmp     [wParam], VK_SPACE
        jne     @f
        fld     [upSpeed]
        fldz
        fcomip  st0,st1
        fstp    [upSpeed]
        jne     .ReturnZero
        fld     [jump]
        fstp    [upSpeed]
        jmp     .ReturnZero
@@:
        
        cmp     [wParam], VK_LEFT
        jne     .skipLeft
        cmp     [colorMenu],1
        jnz      .w
                
                cmp [focusType],1
                jnz @f
                mov [focusType],9
                @@:
                dec [focusType]
        .w:
        mov     byte [pressedKeys],1
        
        .skipLeft: 
               
        cmp     [wParam], VK_RIGHT
        jne     .skipRight
        cmp     [colorMenu],1
        jnz      .s
                
                cmp [focusType],8
                jnz @f
                mov [focusType],0
                @@:
                inc [focusType]
        .s:
        mov     byte [pressedKeys + 1],1
        
        .skipRight:
        cmp     [wParam], VK_UP
        jne     @f
        mov     byte [pressedKeys + 2],1
        
        @@:
        cmp     [wParam], VK_DOWN
        jne     @f
        mov     byte [pressedKeys + 3],1
        
        @@:        
        cmp     [wParam], VK_ESCAPE
        jne     @f
        jmp     .Destroy
        @@:
        
        cmp     [wParam], 'E'
        jne     .skip1
          cmp   [colorMenu],1
          jz    @f
          mov   [colorMenu],1
          invoke  GetCursorPos,lastPos
          jmp   .skip1
          @@:
          mov   [colorMenu],0
          invoke  SetCursorPos,[lastPos.x],[lastPos.y]
        .skip1:
        
        cmp     [wParam], 'R'
        jne     .skip2
          mov   al,0
          cmp   [moveMode],1
          jz    @f
          mov   al,1
          @@:
          mov   [moveMode],al
        .skip2:
        
        jmp     .ReturnZero
        
.KeyUp:
      
        cmp     [wParam], VK_LEFT
        jne     @f
        mov     byte [pressedKeys],0
        
        @@:        
        cmp     [wParam], VK_RIGHT
        jne     @f
        mov     byte [pressedKeys + 1],0
        
        @@:
        cmp     [wParam], VK_UP
        jne     @f
        mov     byte [pressedKeys + 2],0
        
        @@:
        cmp     [wParam], VK_DOWN
        jne     @f
        mov     byte [pressedKeys + 3],0
        
        @@:
        jmp     .ReturnZero
.Destroy:
        invoke  ExitProcess, ebx

.ReturnZero:
        xor     eax, eax

.Return:
        ret
endp

camPos          Vector3      2.0,1.5,-1.5
camTarget       Vector3      0.0,1.5,-1.5

proc Draw

        locals
                currentTime     dd      ?
                verticesCount   dd      ?
                coor            dd      0
                
        endl

        invoke  GetTickCount
        mov     [currentTime], eax

        sub     eax, [time]
        mov     [incTime],eax
        cmp     eax, 10
        jle     .Skip

        mov     eax, [currentTime]
        mov     [time], eax
        
        
.Skip:
        
        fild    [incTime]
        fdiv    [oneSecond]
        fstp    [incTime]
        
        mov     eax, [mesh.verticesCount]
        mov     [verticesCount], eax
        
        
        invoke  glClearColor, 0.14, 0.43, 0.86, 1.0
        cmp     [colorMenu],1
        jnz     @f
          invoke  glClearColor, 1.0, 1.0, 1.0, 1.0
        @@:
        fld     [cameraPosition.x]
        fadd    [cameraFront.x]
        fstp    [targetPosition.x]
        
        fld     [cameraPosition.y]
        fadd    [cameraFront.y]
        fstp    [targetPosition.y]
        
        fld     [cameraPosition.z]
        fadd    [cameraFront.z]
        fstp    [targetPosition.z]
        
        invoke  glClear, GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT

        invoke  glMatrixMode, GL_MODELVIEW
        invoke  glLoadIdentity
        
        
        cmp     [colorMenu],1
        jnz     @f
          stdcall Matrix.LookAt, camPos, camTarget, upVector
          stdcall DrawMenu
          jmp     .menuDraw
        @@:
        
        stdcall Matrix.LookAt, cameraPosition, targetPosition, upVector
        
        stdcall MoveView
        stdcall FindFocusBlock
             
        
        lea edi,[cubeVertices]
        lea esi,[defCubeVertices]
        mov ecx,24
        rep movsd
        
        mov     esi,[cubeArray]
        mov     [coor],esi        
        movzx   ecx,[worldLen]
.loopLen:
        push    ecx
                 
        movzx   ecx,[worldWidth]
.loopWidth:
        push    ecx
        
        movzx   ecx,[worldHeight]
.loopHeight:
        push    ecx
        
        mov     esi,[coor]
        stdcall getColorAndDraw,esi        ;Рисуем новый куб 
               
        inc   [coor]
        lea   esi,[cubeVertices]
        mov   ecx,8
@@:
        fld   [blockSize]   
        fadd  [esi + Vertex.z]
        fstp  [esi + Vertex.z]
        add   esi,sizeof.Vertex
        loop  @b
        
        pop   ecx
        loop  .loopHeight 
        
        lea   esi,[cubeVertices]
        lea   edi,[defCubeVertices + Vertex.z]
        mov   ecx,8
@@:
        fld   [blockSize]   
        fadd  [esi + Vertex.y]
        fstp  [esi + Vertex.y]
        push  dword[edi]
        pop   dword[esi + Vertex.z]  
        add   esi,sizeof.Vertex
        add   edi,sizeof.Vertex
        loop  @b
        
        pop   ecx
        dec   ecx
        cmp   ecx,0
        jne  .loopWidth
        
        lea   esi,[cubeVertices]
        lea   edi,[defCubeVertices + Vertex.y]
        mov   ecx,8
@@:
        fld   [blockSize]   
        fadd  [esi + Vertex.x]
        fstp  [esi + Vertex.x]
        push  dword[edi]
        pop   dword[esi + Vertex.y]  
        add   esi,sizeof.Vertex
        add   edi,sizeof.Vertex
        loop  @b
        
        pop   ecx
        dec   ecx
        cmp   ecx,0
        jne    .loopLen

        stdcall RenewMesh, KriperMesh0, mesh, false        
        stdcall DrawMesh, mesh
        stdcall RenewMesh, KriperMesh1, mesh, false        
        stdcall DrawMesh, mesh
        stdcall RenewMesh, KriperMesh2, mesh, false        
        stdcall DrawMesh, mesh
        stdcall RenewMesh, KriperMesh3, mesh, false        
        stdcall DrawMesh, mesh
        
        stdcall RenewMesh, KriperMesh4, mesh1, false        
        stdcall DrawMesh, mesh1
        stdcall RenewMesh, KriperMesh5, mesh2, false        
        stdcall DrawMesh, mesh2

.menuDraw:
        
        invoke  SwapBuffers, [hdc]       
        
        ret
endp

proc  getColorAndDraw,\
    cord

    locals
       setColor     dd   ?       
    endl
    
    mov   esi,[cord]
    
    xor   eax,eax
    mov   ah,byte [esi]
    
    cmp   ah,0
    jne   @f
    jmp   .Zero
@@: 
    
    dec   ah
    mov   al,12
    mul   ah
    lea   esi,[colors]
    add   esi,eax
    
    lea   edi,[cubeColors]
    mov   [setColor],esi
    mov   ecx,8
@@:
    push  ecx
    
    mov   esi,[setColor]
    mov   ecx,3
    rep   movsd
    
    pop   ecx
    loop @b
    
    mov     esi,[cord]
    cmp     esi,[focusBlock]
    jz      .focus
    stdcall RenewMesh, cubeMesh, mesh, false
    jmp     @f
    .focus:
    stdcall RenewMesh, cubeMesh, mesh, true
    @@:
    stdcall Mesh.CalculateNormals, mesh        
    stdcall DrawMesh, mesh
.Zero:    
    ret
endp

proc Vector3.Distance uses esi edi,\
     v1, v2

        locals
                result  dd      ?
        endl

        mov     esi, [v1]
        mov     edi, [v2]

        fld     [esi + Vector3.x]
        fsub    [edi + Vector3.x]
        fmul    st0, st0

        fld     [esi + Vector3.y]
        fsub    [edi + Vector3.y]
        fmul    st0, st0

        fld     [esi + Vector3.z]
        fsub    [edi + Vector3.z]
        fmul    st0, st0

        faddp
        faddp
        fsqrt
        fstp    [result]

        mov     eax, [result]

        ret
endp

proc Vector3.Length uses esi,\
     vector

        locals
                result  dd      ?
        endl

        mov     esi, [vector]

        fld     [esi + Vector3.x]
        fmul    [esi + Vector3.x]

        fld     [esi + Vector3.y]
        fmul    [esi + Vector3.y]

        fld     [esi + Vector3.z]
        fmul    [esi + Vector3.z]

        faddp
        faddp
        fsqrt
        fstp    [result]

        mov     eax, [result]

        ret
endp

proc Matrix.LookAt uses esi edi ebx,\
     camera, target, up

        locals
                temp    dd              ?
                matrix  Matrix4x4
                zAxis   Vector3
                xAxis   Vector3
                yAxis   Vector3
        endl

        lea     edi, [matrix]
        mov     ecx, 4 * 4
        xor     eax, eax
        rep     stosd

        mov     esi, [camera]
        mov     edi, [target]
        mov     ebx, [up]

        fld     [edi + Vector3.x]
        fsub    [esi + Vector3.x]
        fstp    [zAxis.x]

        fld     [edi + Vector3.y]
        fsub    [esi + Vector3.y]
        fstp    [zAxis.y]

        fld     [edi + Vector3.z]
        fsub    [esi + Vector3.z]
        fstp    [zAxis.z]

        lea     eax, [zAxis]
        stdcall Vector3.Normalize, eax

        lea     eax, [zAxis]
        lea     ecx, [xAxis]
        stdcall Vector3.Cross, eax, ebx, ecx

        lea     eax, [xAxis]
        stdcall Vector3.Normalize, eax

        lea     eax, [xAxis]
        lea     ecx, [zAxis]
        lea     ebx, [yAxis]
        stdcall Vector3.Cross, eax, ecx, ebx

        lea     esi, [xAxis]
        lea     edi, [matrix]
        fld     [esi + Vector3.x]
        fstp    [edi + Matrix4x4.m11]
        fld     [esi + Vector3.y]
        fstp    [edi + Matrix4x4.m21]
        fld     [esi + Vector3.z]
        fstp    [edi + Matrix4x4.m31]

        fld     [ebx + Vector3.x]
        fstp    [edi + Matrix4x4.m12]
        fld     [ebx + Vector3.y]
        fstp    [edi + Matrix4x4.m22]
        fld     [ebx + Vector3.z]
        fstp    [edi + Matrix4x4.m32]

        lea     esi, [zAxis]
        fld     [esi + Vector3.x]
        fchs
        fstp    [edi + Matrix4x4.m13]
        fld     [esi + Vector3.y]
        fchs
        fstp    [edi + Matrix4x4.m23]
        fld     [esi + Vector3.z]
        fchs
        fstp    [edi + Matrix4x4.m33]

        fld1
        fstp    [edi + Matrix4x4.m44]

        invoke  glMultMatrixf, edi

        mov     esi, [camera]
        fld     [esi + Vector3.z]
        fchs
        fstp    [temp]
        push    [temp]
        fld     [esi + Vector3.y]
        fchs
        fstp    [temp]
        push    [temp]
        fld     [esi + Vector3.x]
        fchs
        fstp    [temp]
        push    [temp]
        invoke  glTranslatef

        ret
endp

proc Mesh.CalculateNormals uses esi edi ebx,\
     mesh

        locals
                trianglesCount  dd      ?
                v1              Vector3   ?,?,?
                v2              Vector3   ?,?,?
                normal          Vector3   ?,?,?
        endl

        mov     esi, [mesh]

        mov     eax, [esi + Mesh.verticesCount]
        xor     edx, edx
        mov     ecx, 3
        div     ecx
        mov     [trianglesCount], eax

        mov     edi, [esi + Mesh.normals]
        mov     esi, [esi + Mesh.vertices]

        mov     ecx, [trianglesCount]

.CalculateNormalsLoop:
        push    ecx

        lea     ebx, [v1]
        add     esi, sizeof.Vector3 * 2
        stdcall Vector3.Copy, ebx, esi

        sub     esi, sizeof.Vector3 * 2
        stdcall Vector3.Sub, ebx, esi

        stdcall Vector3.Normalize, ebx

        lea     ebx, [v2]
        add     esi, sizeof.Vector3 * 1
        stdcall Vector3.Copy, ebx, esi

        sub     esi, sizeof.Vector3 * 1
        stdcall Vector3.Sub, ebx, esi

        stdcall Vector3.Normalize, ebx

        lea     ebx, [normal]
        push    ebx
        lea     ebx, [v1]
        push    ebx
        lea     ebx, [v2]
        push    ebx
        stdcall Vector3.Cross

        lea     ebx, [normal]
        stdcall Vector3.Normalize, ebx

        lea     ebx, [normal]
        stdcall Vector3.Copy, edi, ebx
        add     edi, sizeof.Vector3 * 1
        stdcall Vector3.Copy, edi, ebx
        add     edi, sizeof.Vector3 * 1
        stdcall Vector3.Copy, edi, ebx
        add     edi, sizeof.Vector3 * 1

        add     esi, sizeof.Vector3 * 3

        pop     ecx
        loop    .CalculateNormalsLoop

        ret
endp 

proc Vector3.Sub uses esi edi,\
     dest, src

        mov     esi, [src]
        mov     edi, [dest]

        fld     [edi + Vector3.x]
        fsub    [esi + Vector3.x]
        fstp    [edi + Vector3.x]

        fld     [edi + Vector3.y]
        fsub    [esi + Vector3.y]
        fstp    [edi + Vector3.y]

        fld     [edi + Vector3.z]
        fsub    [esi + Vector3.z]
        fstp    [edi + Vector3.z]

        ret
endp

proc Vector3.Copy uses esi edi,\
     dest, src

        mov     esi, [src]
        mov     edi, [dest]
        mov     ecx, 3
        rep     movsd

        ret
endp

; получает координаты блока cord по положении точки. Возвращает в ah - 0 
; если блок существует в рамках карты, 1 - если нет
proc TakeBlock,\    ;toDo
    vector, cord
    
    locals
        tmp      dw    ?
    endl
    mov     ah,0
    
    mov     esi,[vector]
    mov     edi,[cord]
    fld     [esi + Vector3.x]
    fdiv    [blockSize]
    fisttp  [tmp]
    mov     al,byte [tmp]
    cmp     al,[worldLen]
    ja      .outOfBorders
    cmp     al,0
    jb      .outOfBorders
    mov     byte [edi + Coordinate.x],al       
    
    fld     [esi + Vector3.y]
    fdiv    [blockSize]
    fisttp  [tmp]
    mov     al,byte [tmp]    
    cmp     al,[worldWidth]
    ja      .outOfBorders
    cmp     al,0
    jb      .outOfBorders
    mov     byte [edi + Coordinate.y],al 
    
    fld     [esi + Vector3.z]
    fdiv    [blockSize]
    fisttp  [tmp]
    mov     al,byte [tmp]
    cmp     al,[worldHeight]
    ja      .outOfBorders
    cmp     al,0
    jb      .outOfBorders
    mov     byte [edi + Coordinate.z],al
    jmp     @f
.outOfBorders:      
    mov     ah,1
@@:     
    ret
endp

; возвращает ссылку в esi на выбранный по координатам блок и сам тип в ah
proc  getBlockType,\
    block
    
    mov esi,[cubeArray]
    mov edi,[block]
    
    mov   al,byte [edi + Coordinate.x]
    mul   byte [worldWidth]
    movzx dx, [worldHeight]
    mul   dx
    shl   edx,16
    mov   dx,ax
    add   esi,edx
    
    xor   eax,eax
    mov   al,byte [edi + Coordinate.y]
    mul   byte [worldHeight]
    add   esi,eax
    
    xor   eax,eax
    mov   al,byte [edi + Coordinate.z]
    add   esi,eax
    
    mov   ah,byte [esi]
    
    ret
endp

; Находит блок на который направлен взгляд, возвращает ссылку в focusBlock, а также
; блок до него и кладет ссылку в newBlock, если блока нет ставит 0
proc FindFocusBlock

    locals
       tmpPos     Vector3     ?,?,?
       tmpStep    Vector3     ?,?,?
       block      Coordinate  ?,?,?
       step       dd          0.01
    endl

    lea esi,[cameraPosition]
    lea edi,[tmpPos]
    mov ecx,3
    rep movsd 
    
    fld   [cameraFront.x]
    fmul  [step]
    fstp  [tmpStep + Vector3.x]
    
    fld   [cameraFront.y]
    fmul  [step]
    fstp  [tmpStep + Vector3.y]
    
    fld   [cameraFront.z]
    fmul  [step]
    fstp  [tmpStep + Vector3.z] 
    
    lea     esi,[tmpPos]
    lea     edi,[block]
    mov     [focusBlock],0
    mov     [newBlock],0
    ;stdcall TakeBlock,esi,edi
    ;stdcall getBlockType,edi
.cycle:
    fld   [tmpPos.x]
    fadd  [tmpStep + Vector3.x]
    fstp  [tmpPos.x]
    
    fld   [tmpPos.y]
    fadd  [tmpStep + Vector3.y]
    fstp  [tmpPos.y]
    
    fld   [tmpPos.z]
    fadd  [tmpStep + Vector3.z]
    fstp  [tmpPos.z] 
    
    lea     esi,[tmpPos]
    stdcall TakeBlock,esi,edi
    
    cmp     ah,1
    ;jnz     @f
    jz      .endOfCycle
@@:
     
    stdcall getBlockType,edi
    cmp     ah,0
    jz      @f
    mov     [focusBlock],esi
    jmp      .endOfCycle 
@@:    
    mov     [newBlock],esi
    jmp     .cycle
    
.endOfCycle:
 
    ret
endp 


upSpeed       dd        5.0
proc  MoveView
    locals
          speed   dd        2.0
          g       dd        10.0
          tmp     Vector3   ?,?,?
          newPos  Vector3   ?,?,?
          tmpCord Coordinate  ?,?,?
    endl
        fld     [speed]
        fmul    [incTime]
        fstp    [speed]
        
        lea     esi,[cameraPosition]
        lea     edi,[newPos]
        mov     ecx,3
        rep     movsd

        cmp     byte [pressedKeys], 1
        jne     @f
        lea     eax,[cameraFront]
        lea     ecx,[upVector]
        lea     edx,[tmp]
        stdcall Vector3.Cross,eax,ecx,edx

        stdcall Vector3.Normalize,edx
        
        fld     [tmp.x]
        fmul    [speed]
        fstp    [tmp.x]
        
        fld     [tmp.y]
        fmul    [speed]
        fstp    [tmp.y]
        
        fld     [tmp.z]
        fmul    [speed]
        fstp    [tmp.z]
        
        fld     [newPos.x]
        fsub    [tmp.x]
        fstp    [newPos.x]
        
        fld     [newPos.y]
        fsub    [tmp.y]
        fstp    [newPos.y]
        
        fld     [newPos.z]
        fsub    [tmp.z]
        fstp    [newPos.z]
        
        @@:        
        cmp     byte [pressedKeys + 1], 1
        jne     @f
        
        lea     eax,[cameraFront]
        lea     ecx,[upVector]
        lea     edx,[tmp]
        stdcall Vector3.Cross,eax,ecx,edx
        stdcall Vector3.Normalize,edx
        
        fld     [tmp.x]
        fmul    [speed]
        fadd    [newPos.x]
        fstp    [newPos.x]
        
        cmp     [moveMode],0
        jz      .skip1
        fld     [tmp.y]
        fmul    [speed]
        fadd    [newPos.y]
        fstp    [newPos.y]
        .skip1:

        
        fld     [tmp.z]
        fmul    [speed]
        fadd    [newPos.z]
        fstp    [newPos.z]
        
        @@:
        cmp     byte [pressedKeys + 2], 1
        jne     @f
        fld     [cameraFront.x]
        fmul    [speed]
        fadd    [newPos.x]
        fstp    [newPos.x]
        
        cmp     [moveMode],0
        jz      .skip2
        fld     [cameraFront.y]
        fmul    [speed]
        fadd    [newPos.y]
        fstp    [newPos.y]
        .skip2:
        
        fld     [cameraFront.z]
        fmul    [speed]
        fadd    [newPos.z]
        fstp    [newPos.z]
        
        @@:
        cmp     byte [pressedKeys + 3], 1
        jne     @f
        fld     [cameraFront.x]
        fmul    [speed]
        fstp    [tmp.x]
        fld     [newPos.x]
        fsub    [tmp.x]
        fstp    [newPos.x]
        
        cmp     [moveMode],0
        jz      .skip3
        fld     [cameraFront.y]
        fmul    [speed]
        fstp    [tmp.y]
        fld     [newPos.y]
        fsub    [tmp.y]
        fstp    [newPos.y]
        .skip3:
        
        fld     [cameraFront.z]
        fmul    [speed]
        fstp    [tmp.z]
        fld     [newPos.z]
        fsub    [tmp.z]
        fstp    [newPos.z]
        
        @@:
        lea   esi,[newPos]
        lea   edi,[tmpCord]
        stdcall TakeBlock,esi,edi
        cmp   ah,1
        jz    @f
        stdcall getBlockType,edi
        cmp   ah,0
        jnz   @f
        
        fld    [newPos.y]
        fsub   [blockSize]
        fstp   [newPos.y]
        
        lea   esi,[newPos]
        lea   edi,[tmpCord]
        stdcall TakeBlock,esi,edi
        cmp   ah,1
        jz    @f
        stdcall getBlockType,edi
        cmp   ah,0
        jnz   @f
        
        fld    [newPos.y]
        fadd   [blockSize]
        fstp   [newPos.y] 
        lea     esi,[newPos]
        lea     edi,[cameraPosition]
        mov     ecx,3
        rep     movsd 
@@:      
        
;-------------------------------------------------------------------------------
        
        cmp     [moveMode],1
        jz      .skip4
        lea     esi,[cameraPosition]
        lea     edi,[newPos]
        mov     ecx,3
        rep     movsd
        
        fld   [upSpeed]
        fmul  [incTime]
        fadd  [newPos.y]
        fsub  [personSize]     
        fstp  [newPos.y]
        
        lea   esi,[newPos]
        lea   edi,[tmpCord]
        stdcall TakeBlock,esi,edi
        cmp   ah,1
        jz    .zeroflag
        stdcall getBlockType,edi
        cmp   ah,0
        jnz   .zeroflag
        
        fld   [g]
        fmul  [incTime]
        fstp  [g]
        fld   [upSpeed]
        fsub  [g]
        fstp  [upSpeed]
        jmp   @f 

.zeroflag:                
        fldz
        fstp    [upSpeed]

@@:

        fld  [newPos.y]
        fadd [personSize]     
        fstp [newPos.y]
        
        lea   esi,[newPos]
        lea   edi,[tmpCord]
        stdcall TakeBlock,esi,edi
        cmp   ah,1
        jz    @f
        stdcall getBlockType,edi
        cmp   ah,0
        jnz   @f

        lea     esi,[newPos]
        lea     edi,[cameraPosition]
        mov     ecx,3
        rep     movsd   

@@:
.skip4:              
        ret
endp

proc  DrawMenu
        locals
          tmp   dd   0.45
          color db   1
          tmpPos  Vector3 0.0,1.0,1.9
        endl

    lea   ebx,[colors]     
    mov   ecx,8
.cycle:
    push  ecx
    
    mov   dl,[color]
    cmp   [focusType] ,dl
    jnz    @f
    fld   [tmpPos.y]
    fadd  [tmp]
    fstp  [tmpPos.y]
@@:
    
    
    invoke glBegin,GL_QUADS
    invoke glColor3f,[ebx],[ebx + 4],[ebx + 8] 
    invoke glVertex3f,[tmpPos.x],[tmpPos.y],[tmpPos.z]
    fld   [tmpPos.y]
    fadd  [tmp]
    fstp  [tmpPos.y]
    invoke glVertex3f,[tmpPos.x],[tmpPos.y],[tmpPos.z]
    fld   [tmpPos.z]
    fsub  [tmp]
    fstp  [tmpPos.z]
    invoke glVertex3f,[tmpPos.x],[tmpPos.y],[tmpPos.z]
    fld   [tmpPos.y]
    fsub  [tmp]
    fstp  [tmpPos.y]
    invoke glVertex3f,[tmpPos.x],[tmpPos.y],[tmpPos.z]
    fld   [tmpPos.z]
    fsub  [tmp]
    fstp  [tmpPos.z]   
    invoke  glEnd
   
    mov   dl,[color]
    cmp   [focusType] ,dl
    jnz    @f
    fld   [tmpPos.y]
    fsub  [tmp]
    fstp  [tmpPos.y]
@@:
    
    add   ebx,12
    inc   [color]
    pop ecx
    dec ecx
    test  ecx,ecx
    jnz  .cycle
               
    ret
endp

proc  GenerateWorld

    xor     eax,eax
    xor     edx,edx
    mov     al,byte [worldWidth]
    mul     byte [worldLen]
    movzx   cx,byte [worldHeight]
    mul     cx
    shl     edx,16
    mov     dx,ax
    push    edx
    invoke  HeapAlloc, [hHeap], 1
    mov     [cubeArray],eax 
    mov     edi,eax
    movzx   ecx,[worldLen]
.cycle:
    push    ecx
    xor     eax,eax
    mov     al,2
    mul     byte[worldHeight]
    mov     ecx,eax
    mov     al,2
    rep stosb
    movzx   ecx,byte [worldHeight]
    mov     al,1
    rep stosb
    mov     al,byte [worldWidth]
    sub     al,3
    mul     byte [worldHeight]
    movzx   ecx,ax
    mov     al,0
    rep stosb
    pop     ecx
    loop  .cycle
    
  ret
endp


proc File.LoadContent uses edi esi,\
     fileName

        locals
                hFile   dd      ?
                length  dd      ?
                read    dd      ?
                pBuffer dd      ?
        endl
        
        xor     eax,eax
        invoke  CreateFile, [fileName], GENERIC_READ, ebx, ebx, OPEN_EXISTING,\
                        FILE_ATTRIBUTE_NORMAL, ebx
        mov     [hFile], eax
        invoke  GetLastError
        cmp     eax,2
        jz      .fileNotFound
        
        invoke  GetFileSize, [hFile], ebx
        inc     eax
        mov     [length], eax
        invoke  HeapAlloc, [hHeap], 1, [length]
        mov     [pBuffer], eax
        mov     esi,eax
        lea     edi, [read]
        invoke  ReadFile, [hFile], [pBuffer], [length], edi, ebx

        invoke  CloseHandle, [hFile]

        mov   esi, [pBuffer]

        lea   edi,[worldWidth]
        movsb
        lea   edi,[worldLen]
        movsb
        lea   edi,[worldHeight]
        movsb
        
        sub   [length],3
        mov   ecx,[length]
        push  ecx
        push  ecx
        invoke HeapAlloc, [hHeap], 1
        mov   [cubeArray],eax
        mov   edi,eax
        pop   ecx
        rep   movsb
        
.fileNotFound:
        ret
endp

proc File.SaveContent uses edi esi,\
     fileName

        locals
                hFile   dd      ?
                length  dd      ?
                read    dd      ?
                pBuffer dd      ?
        endl
        
        xor     eax,eax
        invoke  CreateFile, [fileName], GENERIC_WRITE, ebx, ebx, CREATE_ALWAYS,\
                        FILE_ATTRIBUTE_NORMAL, ebx
        mov     [hFile], eax
        
        xor   eax,eax
        xor   edx,edx
        mov   al,byte [worldWidth]
        mul   byte [worldLen]
        movzx cx,byte [worldHeight]
        mul   cx
        shl   edx,16
        mov   dx,ax
        push  edx
        push  edx
        add   edx,3
        mov     [length], edx
        invoke  HeapAlloc, [hHeap], 1, [length]
        mov     [pBuffer], eax
        mov     edi,eax
        lea   esi,[worldWidth]
        movsb
        lea   esi,[worldLen]
        movsb
        lea   esi,[worldHeight]
        movsb
        mov   esi,[cubeArray]
        pop   ecx
        rep movsb
        
        lea     edi, [read]
        invoke  WriteFile, [hFile], [pBuffer], [length], edi, ebx

        invoke  CloseHandle, [hFile]
        
.fileNotFound:
        ret
endp



