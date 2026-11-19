document.querySelectorAll('.sidebar a').forEach(a => { if (new URL(a.href).pathname === location.pathname) a.classList.add('active'); });
const form=document.getElementById('todo-form');
if(form){const items=document.getElementById('todo-items');let seq=0;function add(text){const row=document.createElement('div');row.className='task';const check=document.createElement('input');check.type='checkbox';check.id='task-'+(++seq);const label=document.createElement('label');label.htmlFor=check.id;label.textContent=text;const edit=document.createElement('button');edit.textContent='수정';edit.type='button';edit.onclick=()=>{const v=prompt('할 일 수정',label.textContent);if(v&&v.trim())label.textContent=v.trim()};const del=document.createElement('button');del.textContent='삭제';del.type='button';del.onclick=()=>row.remove();row.append(check,label,edit,del);items.append(row)}add('프로젝트 상세 화면 정리');add('로그인 상태 화면 확인');form.addEventListener('submit',e=>{e.preventDefault();const input=document.getElementById('todo-text');if(input.value.trim())add(input.value.trim());input.value=''});}

const board=document.getElementById('mission-board');if(board){const stages=['진행 중','승인 대기','승인 완료'];function refresh(){const cols=board.querySelectorAll('section');let total=0;cols.forEach(col=>{const n=col.querySelectorAll('.mission').length;col.querySelector('h3 span').textContent=n;total+=n});const done=cols[2].querySelectorAll('.mission').length;document.getElementById('mission-progress').textContent='진행률 '+(total?Math.round(done/total*100):0)+'% · 승인 완료 '+done+' / 전체 '+total}board.addEventListener('click',e=>{if(!e.target.classList.contains('move'))return;const card=e.target.closest('.mission');const next=Number(card.parentElement.dataset.stage)+1;board.querySelector('[data-stage="'+next+'"]').append(card);card.querySelector('.tag').textContent=stages[next];if(next===2)e.target.remove();else e.target.textContent='팀장 승인';refresh()});document.getElementById('new-mission').onclick=()=>{const name=prompt('미션 이름');if(!name||!name.trim())return;const card=document.createElement('article');card.className='panel mission';const tag=document.createElement('span');tag.className='tag';tag.textContent=stages[0];const title=document.createElement('h3');title.textContent=name.trim();const button=document.createElement('button');button.className='btn move';button.textContent='내 작업 완료';card.append(tag,title,button);board.querySelector('[data-stage="0"]').append(card);refresh()}}

const calendar = document.getElementById('weekly-calendar');
if (calendar) {
    const days = ['월','화','수','목','금','토','일'];
    const people = ['나','팀원 A','팀원 B','팀원 C'];
    const colors = ['#d9e7f4','#e4d3ef','#f5e2bc','#d9ead0'];
    const first = 0, last = 48;
    const storageKey = 'teamMatching.preview.schedule.v2';
    let data = {};
    try { data = JSON.parse(localStorage.getItem(storageKey) || '{}') || {}; } catch(e) {}
    const dateKey = d => `${d.getFullYear()}-${String(d.getMonth()+1).padStart(2,'0')}-${String(d.getDate()).padStart(2,'0')}`;
    const addDays = (d,n) => { const x=new Date(d); x.setDate(x.getDate()+n); return x; };
    let week = new Date(); week.setHours(0,0,0,0); week=addDays(week,-((week.getDay()+6)%7));
    const time = n => `${String(Math.floor(n/2)).padStart(2,'0')}:${n%2?'30':'00'}`;
    const key = (d,t) => `${d}-${t}`;
    const current = () => { const k=dateKey(week); if(!data[k]) data[k]={mine:[],events:[]}; return data[k]; };
    const persist = () => { try { localStorage.setItem(storageKey,JSON.stringify(data)); } catch(e) { alert('브라우저 저장 공간을 사용할 수 없습니다.'); } };
    const sample = (i,d,t) => i===1 ? d<5&&t>=32&&t<38 : i===2 ? d>=1&&d<=4&&t>=34&&t<40 : d>=2&&d<=4&&t>=34&&t<38;
    const available = (i,d,t) => i===0 ? current().mine.includes(key(d,t)) : sample(i,d,t);
    const heading = () => `${dateKey(week)} ~ ${dateKey(addDays(week,6))}`;
    const legend=document.getElementById('calendar-legend');
    people.concat(['공통 가능','팀 일정']).forEach((name,i)=>{const span=document.createElement('span');span.className='legend-item';const dot=document.createElement('i');dot.style.background=colors[i]|| (i===4?'#a5c69b':'#650d2b');span.append(dot,document.createTextNode(name));legend.append(span);});
    function build(table,editing) {
        const head=table.tHead, body=table.tBodies[0];head.replaceChildren();body.replaceChildren();
        const tr=head.insertRow();const th=document.createElement('th');th.textContent='시간';tr.append(th);
        days.forEach((name,d)=>{const h=document.createElement('th');const date=addDays(week,d);h.textContent=`${name} ${date.getMonth()+1}/${date.getDate()}`;if(dateKey(date)===dateKey(new Date()))h.className='today';tr.append(h);});
        for(let t=first;t<last;t++){
            const row=body.insertRow();const label=document.createElement('th');label.textContent=time(t);row.append(label);
            for(let d=0;d<7;d++){
                const td=row.insertCell();td.dataset.slot=key(d,t);
                if(editing){const button=document.createElement('button');button.type='button';button.className='slot';button.dataset.slot=key(d,t);button.setAttribute('aria-label',`${days[d]} ${time(t)}`);td.append(button);continue;}
                const all=people.every((_,i)=>available(i,d,t));if(all)td.classList.add('common-slot');
                people.forEach((name,i)=>{if(available(i,d,t)){const tag=document.createElement('span');tag.className='person-slot';tag.style.background=colors[i];tag.textContent=name;td.append(tag);}});
                current().events.filter(e=>e.day===d&&t>=e.start&&t<e.end).forEach(e=>{const tag=document.createElement('span');tag.className='event-slot';tag.textContent=e.name;td.append(tag);});
            }
        }
    }
    function renderTeamSchedule() {
        const list = document.getElementById('team-schedule-list');
        if (!list) return;
        list.replaceChildren();
        const events = [...current().events].sort((a,b) => a.day-b.day || a.start-b.start || a.end-b.end);
        if (!events.length) {
            const empty = document.createElement('p');
            empty.className = 'muted';
            empty.textContent = '이번 주 등록된 팀 일정이 없습니다.';
            list.append(empty);
            return;
        }
        events.forEach(event => {
            const date = addDays(week,event.day);
            const row = document.createElement('div');
            row.className = 'task';
            const dateLabel = document.createElement('span');
            dateLabel.className = 'tag';
            dateLabel.textContent = `${date.getMonth()+1}/${date.getDate()} (${days[event.day]})`;
            const info = document.createElement('div');
            info.style.flex = '1';
            info.style.minWidth = '0';
            info.style.overflowWrap = 'anywhere';
            const name = document.createElement('strong');
            name.textContent = event.name;
            const detail = document.createElement('small');
            detail.style.display = 'block';
            detail.textContent = `${time(event.start)} ~ ${time(event.end)}`;
            info.append(name,detail);
            row.append(dateLabel,info);
            list.append(row);
        });
    }
    function render(){renderTeamSchedule();document.getElementById('week-title').textContent=heading();build(calendar,false);const list=document.getElementById('availability-list');list.replaceChildren();for(let d=0;d<7;d++){let t=first;while(t<last){if(!people.every((_,i)=>available(i,d,t))){t++;continue;}const start=t;while(t<last&&people.every((_,i)=>available(i,d,t)))t++;const item=document.createElement('p');item.className='tag';item.textContent=`${days[d]}요일 ${time(start)} ~ ${time(t)}`;list.append(item);}}if(!list.children.length)list.textContent='모든 팀원이 가능한 시간이 없습니다.';}
    document.getElementById('prev-week').onclick=()=>{week=addDays(week,-7);render();};
    document.getElementById('next-week').onclick=()=>{week=addDays(week,7);render();};
    const dialog=document.getElementById('availability-dialog'), grid=document.getElementById('availability-grid');let draft=new Set(), dragging=false, paint=true;
    function update(){grid.querySelectorAll('button.slot').forEach(b=>{const selected=draft.has(b.dataset.slot);b.classList.toggle('selected',selected);b.setAttribute('aria-pressed',String(selected));});document.getElementById('selected-count').textContent=`선택한 시간: ${draft.size*30}분`;}
    function apply(b){if(!b)return;if(paint)draft.add(b.dataset.slot);else draft.delete(b.dataset.slot);update();}
    document.getElementById('available').onclick=()=>{draft=new Set(current().mine);document.getElementById('input-week').textContent=heading();build(grid,true);update();dialog.showModal();};
    grid.addEventListener('pointerdown',e=>{const b=e.target.closest('button.slot');if(!b||e.button!==0)return;e.preventDefault();dragging=true;paint=!draft.has(b.dataset.slot);apply(b);});
    grid.addEventListener('pointermove',e=>{if(!dragging)return;const b=document.elementFromPoint(e.clientX,e.clientY)?.closest('button.slot');if(b&&grid.contains(b))apply(b);});
    window.addEventListener('pointerup',()=>dragging=false);window.addEventListener('pointercancel',()=>dragging=false);
    grid.addEventListener('click',e=>{const b=e.target.closest('button.slot');if(b&&e.detail===0){paint=!draft.has(b.dataset.slot);apply(b);}});
    document.getElementById('clear-availability').onclick=()=>{draft.clear();update();};
    document.getElementById('close-availability').onclick=()=>dialog.close();
    document.getElementById('save-availability').onclick=()=>{current().mine=[...draft];persist();dialog.close();render();};
    const eventDialog=document.getElementById('schedule-dialog'), start=document.getElementById('event-start'), end=document.getElementById('event-end');
    for(let t=first;t<=last;t++){if(t<last)start.add(new Option(time(t),t));if(t>first)end.add(new Option(time(t),t));}
    document.getElementById('schedule').onclick=()=>{document.getElementById('schedule-form').reset();const input=document.getElementById('event-date');input.min=dateKey(week);input.max=dateKey(addDays(week,6));input.value=input.min;start.value='34';end.value='36';eventDialog.showModal();};
    document.getElementById('cancel-event').onclick=()=>eventDialog.close();
    document.getElementById('schedule-form').onsubmit=e=>{e.preventDefault();const name=document.getElementById('event-name').value.trim(), date=document.getElementById('event-date').value;const day=days.findIndex((_,i)=>dateKey(addDays(week,i))===date);if(!name||day<0||Number(start.value)>=Number(end.value)){alert('일정 이름과 날짜, 시간 범위를 확인하세요.');return;}current().events.push({name,day,start:Number(start.value),end:Number(end.value)});persist();eventDialog.close();render();};
    render();
}
