const http = require('http');
const fs = require('fs');
const path = require('path');
const { spawn } = require('child_process');

const PORT = 3456;
const CHROME_PORT = 9333;
const ROOT_DIR = __dirname;
const SCREENSHOTS_DIR = path.join(ROOT_DIR, 'screenshots');
const ARTIFACTS_DIR = 'C:\\Users\\visha\\.gemini\\antigravity\\brain\\1f33a353-c3a3-4d44-bfd3-8c9c8252e3b1';

if (!fs.existsSync(SCREENSHOTS_DIR)) {
  fs.mkdirSync(SCREENSHOTS_DIR, { recursive: true });
}
if (!fs.existsSync(ARTIFACTS_DIR)) {
  fs.mkdirSync(ARTIFACTS_DIR, { recursive: true });
}

const MIME_TYPES = {
  '.html': 'text/html',
  '.js': 'text/javascript',
  '.css': 'text/css',
  '.json': 'application/json',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.svg': 'image/svg+xml'
};

const server = http.createServer((req, res) => {
  let reqUrl = req.url.split('?')[0];
  if (reqUrl === '/') reqUrl = '/index.html';
  const filePath = path.join(ROOT_DIR, decodeURIComponent(reqUrl));

  fs.readFile(filePath, (err, data) => {
    if (err) {
      res.writeHead(404, { 'Content-Type': 'text/plain' });
      res.end('Not Found');
      return;
    }
    const ext = path.extname(filePath).toLowerCase();
    const contentType = MIME_TYPES[ext] || 'application/octet-stream';
    res.writeHead(200, { 'Content-Type': contentType });
    res.end(data);
  });
});

async function main() {
  await new Promise(resolve => server.listen(PORT, resolve));
  console.log(`Local server listening on http://localhost:${PORT}`);

  const chromePath = 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe';
  const userDataDir = path.join(ROOT_DIR, '.chrome_temp');

  const chromeProcess = spawn(chromePath, [
    `--remote-debugging-port=${CHROME_PORT}`,
    '--headless=new',
    '--disable-gpu',
    '--no-first-run',
    '--no-default-browser-check',
    `--user-data-dir=${userDataDir}`,
    '--window-size=440,950',
    'about:blank'
  ]);

  await new Promise(r => setTimeout(r, 2000));

  let versionInfo;
  for (let i = 0; i < 15; i++) {
    try {
      const resp = await fetch(`http://127.0.0.1:${CHROME_PORT}/json/version`);
      versionInfo = await resp.json();
      break;
    } catch (e) {
      await new Promise(r => setTimeout(r, 500));
    }
  }

  if (!versionInfo || !versionInfo.webSocketDebuggerUrl) {
    console.error('Failed to get Chrome debugger url');
    chromeProcess.kill();
    server.close();
    process.exit(1);
  }

  console.log('Connected to Chrome DevTools Protocol');

  const targetResp = await fetch(`http://127.0.0.1:${CHROME_PORT}/json/new?http://localhost:${PORT}/index.html`, { method: 'PUT' });
  const target = await targetResp.json();
  const wsUrl = target.webSocketDebuggerUrl;

  const ws = new WebSocket(wsUrl);

  let idCounter = 1;
  const callbacks = new Map();

  ws.onmessage = (event) => {
    const msg = JSON.parse(event.data);
    if (msg.id && callbacks.has(msg.id)) {
      const cb = callbacks.get(msg.id);
      callbacks.delete(msg.id);
      if (msg.error) cb.reject(msg.error);
      else cb.resolve(msg.result);
    }
  };

  await new Promise((resolve, reject) => {
    ws.onopen = resolve;
    ws.onerror = reject;
  });

  function send(method, params = {}) {
    return new Promise((resolve, reject) => {
      const id = idCounter++;
      callbacks.set(id, { resolve, reject });
      ws.send(JSON.stringify({ id, method, params }));
    });
  }

  await send('Page.enable');
  await send('Runtime.enable');
  await send('DOM.enable');

  await send('Emulation.setDeviceMetricsOverride', {
    width: 412,
    height: 915,
    deviceScaleFactor: 2.5,
    mobile: true,
    fitWindow: false
  });

  await send('Page.navigate', { url: `http://localhost:${PORT}/index.html` });
  await new Promise(r => setTimeout(r, 3000));

  async function evaluate(code) {
    const res = await send('Runtime.evaluate', {
      expression: `(() => { try { ${code}; return true; } catch(e) { return e.toString(); } })()`,
      returnByValue: true
    });
    if (res.result && typeof res.result.value === 'string' && res.result.value.startsWith('Error')) {
      console.warn('Evaluation note:', res.result.value);
    }
    return res.result?.value;
  }

  async function capture(filename, description) {
    await new Promise(r => setTimeout(r, 1500));
    const screenshotRes = await send('Page.captureScreenshot', {
      format: 'png',
      captureBeyondViewport: false
    });

    const buffer = Buffer.from(screenshotRes.data, 'base64');
    const localFilePath = path.join(SCREENSHOTS_DIR, filename);
    const artifactFilePath = path.join(ARTIFACTS_DIR, filename);

    fs.writeFileSync(localFilePath, buffer);
    fs.writeFileSync(artifactFilePath, buffer);
    console.log(`✓ Captured: ${filename} - ${description}`);
  }

  console.log('Starting high-resolution screenshot captures...');

  // 1. Screen 1: Driver Sign In
  await evaluate(`
    window.navigateToScreen('screenLogin');
    if (window.lucide) window.lucide.createIcons();
  `);
  await capture('01_login_screen.png', 'Screen 1: Emergency Driver Sign In');

  // 2. Screen 2: Login & Start Duty Welcome Notification Popup
  await evaluate(`
    const loginBtn = document.getElementById('loginSubmitBtn');
    if (loginBtn) loginBtn.click();
    if (window.lucide) window.lucide.createIcons();
  `);
  await capture('02_on_duty_welcome_popup.png', 'Screen 2: Duty Started Welcome Notification Banner');

  // 3. Screen 3: Waiting for Emergency / On-Duty Radar Dashboard
  await evaluate(`
    const popup = document.getElementById('dutyStartedPopup');
    if (popup) popup.classList.remove('show');
    if (window.lucide) window.lucide.createIcons();
  `);
  await capture('03_waiting_dashboard.png', 'Screen 3: Active On-Duty Radar Dashboard');

  // 4. Screen 4: Incoming Emergency Call Alert
  await evaluate(`
    const dispatchBtn = document.getElementById('simulateDispatchBtn');
    if (dispatchBtn) dispatchBtn.click();
    if (window.lucide) window.lucide.createIcons();
  `);
  await capture('04_incoming_emergency_alert.png', 'Screen 4: Incoming Emergency Dispatch Call Alert');

  // 5. Screen 5: Active Incident Navigation (Live Map & Turn-by-Turn)
  await evaluate(`
    const swipeThumb = document.getElementById('swipeThumb');
    if (swipeThumb) swipeThumb.click();
  `);
  await new Promise(r => setTimeout(r, 2000));
  await evaluate(`
    if (window.AppState && window.AppState.map) {
      window.AppState.map.invalidateSize();
    }
    if (window.lucide) window.lucide.createIcons();
  `);
  await capture('05_incident_navigation.png', 'Screen 5: Turn-by-Turn Navigation to Incident Location');

  // 6. Screen 6: Incident Arrival & AI Hospital Recommendation / Telemetry
  await evaluate(`
    const arrivedBtn = document.getElementById('markArrivedBtn');
    if (arrivedBtn) arrivedBtn.click();
    if (window.lucide) window.lucide.createIcons();
  `);
  await capture('06_incident_arrival_hospital_eval.png', 'Screen 6: Vitals Telemetry & Intelligent Hospital Recommendation');

  // 7. Screen 7: Hospital Navigation (Route & ER Availability)
  await evaluate(`
    const startTripThumb = document.getElementById('slideStartTripThumb');
    if (startTripThumb) startTripThumb.click();
  `);
  await new Promise(r => setTimeout(r, 2000));
  await evaluate(`
    if (window.AppState && window.AppState.hospitalMap) {
      window.AppState.hospitalMap.invalidateSize();
    }
    if (window.lucide) window.lucide.createIcons();
  `);
  await capture('07_hospital_navigation.png', 'Screen 7: Live Navigation to Hospital & Bed Tracker');

  // 8. Screen 8: Dynamic Reroute Alert (Live Availability Changed)
  await evaluate(`
    const rerouteBtn = document.getElementById('simulateHospInavailabilityBtn');
    if (rerouteBtn) rerouteBtn.click();
    if (window.AppState && window.AppState.hospitalMap) {
      window.AppState.hospitalMap.invalidateSize();
    }
    if (window.lucide) window.lucide.createIcons();
  `);
  await capture('08_hospital_dynamic_reroute.png', 'Screen 8: Dynamic Emergency Reroute Alert');

  // 9. Screen 9: Mission Completed / Handover Audit Report
  await evaluate(`
    const markHospArrived = document.getElementById('markHospArrivedBtn');
    if (markHospArrived) markHospArrived.click();
    if (window.lucide) window.lucide.createIcons();
  `);
  await capture('09_case_completed_summary.png', 'Screen 9: Mission Completed & Doctor Handover Summary');

  // 10. Screen 10: Driver Profile & Shift Statistics Modal
  await evaluate(`
    const backBtn = document.getElementById('backToDutyBtn');
    if (backBtn) backBtn.click();
    const openProf = document.getElementById('openProfileBtn');
    if (openProf) openProf.click();
    if (window.lucide) window.lucide.createIcons();
  `);
  await capture('10_driver_profile_modal.png', 'Screen 10: Driver Profile & Performance Stats');

  // 11. Screen 11: Emergency Case History Audit Modal
  await evaluate(`
    const closeProf = document.getElementById('closeProfileModalBtn');
    if (closeProf) closeProf.click();
    const openHist = document.getElementById('openHistoryBtn');
    if (openHist) openHist.click();
    if (window.lucide) window.lucide.createIcons();
  `);
  await capture('11_case_history_modal.png', 'Screen 11: Recent Emergency History & Handover Logs');

  // 12. Screen 12: Emergency Support Modal
  await evaluate(`
    const closeHist = document.getElementById('closeHistoryModalBtn');
    if (closeHist) closeHist.click();
    const modalSupport = document.getElementById('modalSupport');
    if (modalSupport) modalSupport.classList.remove('hidden');
    if (window.lucide) window.lucide.createIcons();
  `);
  await capture('12_emergency_support_modal.png', 'Screen 12: Control Room Support Desk');

  // 13. Screen 13: Tamil Regional Language View (தமிழ் இடைமுகம்)
  await evaluate(`
    const modalSupport = document.getElementById('modalSupport');
    if (modalSupport) modalSupport.classList.add('hidden');
    if (window.setLanguage) window.setLanguage('ta');
    if (window.lucide) window.lucide.createIcons();
  `);
  await capture('13_tamil_bilingual_dashboard.png', 'Screen 13: Tamil Regional Interface (தமிழ் இடைமுகம்)');

  // Reset back to English
  await evaluate(`
    if (window.setLanguage) window.setLanguage('en');
  `);

  console.log('ALL 13 PAGES & VIEWS CAPTURED SUCCESSFULLY!');

  ws.close();
  chromeProcess.kill();
  server.close();
  process.exit(0);
}

main().catch(err => {
  console.error('Fatal Script Error:', err);
  process.exit(1);
});
