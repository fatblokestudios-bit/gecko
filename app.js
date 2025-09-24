// App State
let counter = 0;
let deferredPrompt;

// Initialize App
document.addEventListener('DOMContentLoaded', function() {
    updateTime();
    setInterval(updateTime, 1000);
    
    // Register Service Worker
    if ('serviceWorker' in navigator) {
        navigator.serviceWorker.register('/sw.js')
            .then(registration => console.log('SW registered'))
            .catch(error => console.log('SW registration failed'));
    }
    
    // Handle Install Prompt
    window.addEventListener('beforeinstallprompt', (e) => {
        e.preventDefault();
        deferredPrompt = e;
        showInstallButton();
    });
});

// Update Status Bar Time
function updateTime() {
    const now = new Date();
    const timeString = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
    document.getElementById('time').textContent = timeString;
}

// Show Install Button
function showInstallButton() {
    const installBtn = document.getElementById('installBtn');
    installBtn.style.display = 'block';
    installBtn.addEventListener('click', installApp);
}

// Install App
async function installApp() {
    if (deferredPrompt) {
        deferredPrompt.prompt();
        const { outcome } = await deferredPrompt.userChoice;
        console.log(`User response to the install prompt: ${outcome}`);
        deferredPrompt = null;
        document.getElementById('installBtn').style.display = 'none';
    }
}

// Counter Functions
function incrementCounter() {
    counter++;
    updateCounter();
    vibrate();
}

function decrementCounter() {
    counter--;
    updateCounter();
    vibrate();
}

function updateCounter() {
    document.getElementById('counter').textContent = counter;
}

// Feature Functions
function vibrate() {
    if ('vibrate' in navigator) {
        navigator.vibrate(50);
        updateStatus('✨ Vibration activated!');
    } else {
        updateStatus('❌ Vibration not supported');
    }
}

function getLocation() {
    updateStatus('📍 Getting location...');
    
    if ('geolocation' in navigator) {
        navigator.geolocation.getCurrentPosition(
            (position) => {
                const { latitude, longitude } = position.coords;
                updateStatus(`📍 Location: ${latitude.toFixed(4)}, ${longitude.toFixed(4)}`);
            },
            (error) => {
                updateStatus('❌ Location access denied');
            }
        );
    } else {
        updateStatus('❌ Geolocation not supported');
    }
}

function toggleFullscreen() {
    if (!document.fullscreenElement) {
        document.documentElement.requestFullscreen().then(() => {
            updateStatus('🔳 Entered fullscreen mode');
        }).catch(() => {
            updateStatus('❌ Fullscreen not supported');
        });
    } else {
        document.exitFullscreen().then(() => {
            updateStatus('🔳 Exited fullscreen mode');
        });
    }
}

function shareApp() {
    if (navigator.share) {
        navigator.share({
            title: 'Mobile App',
            text: 'Check out this awesome mobile web app!',
            url: window.location.href
        }).then(() => {
            updateStatus('🔗 App shared successfully!');
        }).catch(() => {
            updateStatus('❌ Sharing cancelled');
        });
    } else {
        // Fallback: Copy to clipboard
        navigator.clipboard.writeText(window.location.href).then(() => {
            updateStatus('🔗 URL copied to clipboard!');
        }).catch(() => {
            updateStatus('❌ Sharing not supported');
        });
    }
}

// Navigation
function switchTab(tab) {
    // Remove active class from all nav items
    document.querySelectorAll('.nav-item').forEach(item => {
        item.classList.remove('active');
    });
    
    // Add active class to clicked item
    event.target.closest('.nav-item').classList.add('active');
    
    // Update status
    updateStatus(`📱 Switched to ${tab} tab`);
    vibrate();
}

// Update Status Display
function updateStatus(message) {
    const statusDisplay = document.getElementById('statusDisplay');
    statusDisplay.textContent = message;
    statusDisplay.classList.add('loading');
    
    setTimeout(() => {
        statusDisplay.classList.remove('loading');
    }, 1000);
}

// Touch and Gesture Handling
let touchStartY = 0;
let touchEndY = 0;

document.addEventListener('touchstart', e => {
    touchStartY = e.changedTouches[0].screenY;
});

document.addEventListener('touchend', e => {
    touchEndY = e.changedTouches[0].screenY;
    handleSwipe();
});

function handleSwipe() {
    const swipeDistance = touchStartY - touchEndY;
    const minSwipeDistance = 50;
    
    if (Math.abs(swipeDistance) > minSwipeDistance) {
        if (swipeDistance > 0) {
            updateStatus('⬆️ Swiped up!');
        } else {
            updateStatus('⬇️ Swiped down!');
        }
        vibrate();
    }
}

// Prevent default touch behaviors
document.addEventListener('touchmove', function(e) {
    e.preventDefault();
}, { passive: false });

// Handle orientation change
window.addEventListener('orientationchange', function() {
    setTimeout(() => {
        updateStatus('🔄 Orientation changed');
    }, 100);
});