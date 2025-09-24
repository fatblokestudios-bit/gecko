// App State
let currentTab = 'restaurants';
let userSubscription = localStorage.getItem('geckoSubscription') || 'free';
let reputationPoints = parseInt(localStorage.getItem('reputationPoints')) || 120;
let deferredPrompt;

// Level progress calculation (200 points per level)
function updateLevelProgress() {
    const levelProgress = (reputationPoints % 200) / 200;
    const progressFill = document.getElementById('progressFill');
    if (progressFill) {
        progressFill.style.width = (levelProgress * 100) + '%';
    }
}

// Initialize App
document.addEventListener('DOMContentLoaded', function() {
    updateTime();
    setInterval(updateTime, 1000);
    
    // Initialize app content
    initializeApp();
    
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

// Navigation Functions
function switchTab(tab) {
    // Remove active class from all nav items
    document.querySelectorAll('.nav-item').forEach(item => {
        item.classList.remove('active');
    });
    
    // Add active class to clicked item
    event.target.closest('.nav-item').classList.add('active');
    
    // Hide all pages
    document.querySelectorAll('.page').forEach(page => {
        page.classList.add('hidden');
    });
    
    // Show selected page
    const pageMap = {
        'restaurants': 'restaurantsPage',
        'profile': 'profilePage', 
        'unlimited': 'paywallPage'
    };
    
    document.getElementById(pageMap[tab]).classList.remove('hidden');
    currentTab = tab;
    
    vibrate();
}

// Subscription Functions
function subscribe(plan) {
    if (plan === 'monthly') {
        userSubscription = 'unlimited';
        updateStatus('🎉 Subscribed to Gecko Unlimited Monthly!');
        // Add bonus reputation points for subscribing
        reputationPoints += 20;
    } else if (plan === 'lifetime') {
        userSubscription = 'lifetime';
        updateStatus('🎉 Purchased Gecko Unlimited Lifetime!');
        // Add bonus reputation points for lifetime subscription
        reputationPoints += 50;
    }
    
    localStorage.setItem('geckoSubscription', userSubscription);
    localStorage.setItem('reputationPoints', reputationPoints);
    updateReputationDisplay();
    vibrate();
}

// Restaurant Card Click Handler
function handleRestaurantClick(event) {
    const card = event.target.closest('.restaurant-card');
    if (!card) return;
    
    const name = card.querySelector('h3').textContent;
    updateStatus(`🍴 Selected ${name}`);
    
    // Add reputation points for interaction
    reputationPoints += 1;
    localStorage.setItem('reputationPoints', reputationPoints);
    updateReputationDisplay();
    vibrate();
}

// Update reputation display and progress bar
function updateReputationDisplay() {
    document.getElementById('reputationPoints').textContent = reputationPoints;
    updateLevelProgress();
}

function switchTabProgrammatically(tab) {
    // Find the corresponding nav button and trigger click
    const navButtons = document.querySelectorAll('.nav-item');
    const tabMap = { 'restaurants': 0, 'profile': 1, 'unlimited': 2 };
    navButtons[tabMap[tab]].click();
}

// Feature Functions
function vibrate() {
    if ('vibrate' in navigator) {
        navigator.vibrate(50);
    }
}

function shareApp() {
    if (navigator.share) {
        navigator.share({
            title: 'Gluten Free Gecko SEA',
            text: 'Find the best gluten-free restaurants in Southeast Asia!',
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

// Initialize App Content
function initializeApp() {
    // Update reputation display and progress bar
    updateReputationDisplay();
    
    // Add click handlers to restaurant cards
    document.querySelectorAll('.restaurant-card').forEach(card => {
        card.addEventListener('click', handleRestaurantClick);
    });
    
    // Show subscription status
    if (userSubscription !== 'free') {
        updateStatus(`🎉 You have Gecko ${userSubscription === 'lifetime' ? 'Lifetime' : 'Unlimited'}!`);
    } else {
        updateStatus('🦎 Welcome to Gluten Free Gecko SEA!');
    }
}

// Update Status Display
function updateStatus(message) {
    // Create a temporary status message that appears at the bottom
    const existingStatus = document.querySelector('.temp-status');
    if (existingStatus) {
        existingStatus.remove();
    }
    
    const statusDiv = document.createElement('div');
    statusDiv.className = 'temp-status';
    statusDiv.textContent = message;
    statusDiv.style.cssText = `
        position: fixed;
        bottom: 100px;
        left: 50%;
        transform: translateX(-50%);
        background: rgba(0, 0, 0, 0.8);
        color: white;
        padding: 12px 20px;
        border-radius: 20px;
        z-index: 1000;
        font-size: 14px;
        max-width: 300px;
        text-align: center;
        animation: slideUp 0.3s ease-out;
    `;
    
    // Add animation
    const style = document.createElement('style');
    style.textContent = `
        @keyframes slideUp {
            from { opacity: 0; transform: translate(-50%, 20px); }
            to { opacity: 1; transform: translate(-50%, 0); }
        }
    `;
    document.head.appendChild(style);
    
    document.body.appendChild(statusDiv);
    
    setTimeout(() => {
        statusDiv.remove();
    }, 3000);
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