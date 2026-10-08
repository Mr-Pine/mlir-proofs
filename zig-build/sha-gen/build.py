import sys, re, subprocess
sorry = 'sorry' in sys.argv
HERE=__import__('os').path.dirname(__import__('os').path.abspath(__file__))
parts=HERE+'/parts/'
def rd(f): return open(f).read()
ARGS=[f"{t},4" for t in range(0,80,4)]
chunks=subprocess.run(['python3','-I',HERE+'/final.py']+ARGS,capture_output=True,text=True).stdout
comp=subprocess.run(['python3','-I',HERE+'/compose.py'],capture_output=True,text=True).stdout
if sorry:
    out=[];skip=False
    for line in chunks.split('\n'):
        if skip:
            if line.startswith('set_option') or line.startswith('/--') or line.startswith('theorem'):
                skip=False
            else: continue
        out.append(line)
        if line.startswith('    BODY E ') and line.endswith(':= by'):
            out.append('  sorry'); skip=True
    chunks='\n'.join(out)
body = rd(parts+'head.lean')+rd(parts+'consts2.txt')+rd(parts+'mid.lean')+chunks+'\n'+comp+'\n'+rd(parts+'loops_test.lean')+rd(parts+'loop2.lean')+rd(parts+'loop3.lean')+rd(parts+'glue.lean')+rd(parts+'main.lean')
open(sys.argv[1],'w').write(body)
