#!/bin/bash

################################
# 🦎 REVOLT STARTUP SCRIPT 🦎 #
################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker and try again."
        exit 1
    fi
    print_success "Docker is running"
}

# Check if required files exist
check_files() {
    if [ ! -f "revolt.compose.yaml" ]; then
        print_error "revolt.compose.yaml not found in current directory"
        exit 1
    fi
    
    if [ ! -f "revolt.env" ]; then
        print_warning "revolt.env not found. Using default configuration."
    fi
    
    if [ ! -f "nginx.conf" ]; then
        print_warning "nginx.conf not found. Nginx will not be started."
    fi
    
    print_success "Required files checked"
}

# Start Revolt services
start_revolt() {
    print_status "Starting Revolt services..."
    
    # Pull latest images
    print_status "Pulling latest Docker images..."
    docker-compose -f revolt.compose.yaml pull
    
    # Start services
    print_status "Starting containers..."
    docker-compose -f revolt.compose.yaml up -d
    
    print_success "Revolt services started successfully!"
}

# Stop Revolt services
stop_revolt() {
    print_status "Stopping Revolt services..."
    docker-compose -f revolt.compose.yaml down
    print_success "Revolt services stopped"
}

# Restart Revolt services
restart_revolt() {
    print_status "Restarting Revolt services..."
    docker-compose -f revolt.compose.yaml restart
    print_success "Revolt services restarted"
}

# Show status
show_status() {
    print_status "Checking service status..."
    docker-compose -f revolt.compose.yaml ps
}

# Show logs
show_logs() {
    print_status "Showing logs (Ctrl+C to exit)..."
    docker-compose -f revolt.compose.yaml logs -f
}

# Backup data
backup_data() {
    print_status "Creating backup..."
    
    # Create backup directory
    BACKUP_DIR="backups/$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    # Backup MongoDB
    print_status "Backing up MongoDB..."
    docker exec revolt-mongodb mongodump --out /data/backup || print_warning "MongoDB backup failed"
    
    # Backup uploads
    print_status "Backing up uploads..."
    docker cp revolt-api:/app/uploads "$BACKUP_DIR/uploads" 2>/dev/null || print_warning "Uploads backup failed"
    
    # Backup configuration
    print_status "Backing up configuration..."
    cp revolt.env "$BACKUP_DIR/" 2>/dev/null || print_warning "Environment backup failed"
    cp nginx.conf "$BACKUP_DIR/" 2>/dev/null || print_warning "Nginx config backup failed"
    
    print_success "Backup created in $BACKUP_DIR"
}

# Update services
update_revolt() {
    print_status "Updating Revolt services..."
    
    # Pull latest images
    docker-compose -f revolt.compose.yaml pull
    
    # Restart services
    docker-compose -f revolt.compose.yaml up -d
    
    print_success "Revolt services updated and restarted"
}

# Show help
show_help() {
    echo "Revolt Self-Hosted Management Script"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  start     Start Revolt services"
    echo "  stop      Stop Revolt services"
    echo "  restart   Restart Revolt services"
    echo "  status    Show service status"
    echo "  logs      Show service logs"
    echo "  backup    Create backup of data and configuration"
    echo "  update    Update to latest versions"
    echo "  help      Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 start    # Start all services"
    echo "  $0 logs     # View logs"
    echo "  $0 backup   # Create backup"
}

# Main script logic
main() {
    case "${1:-start}" in
        start)
            check_docker
            check_files
            start_revolt
            ;;
        stop)
            stop_revolt
            ;;
        restart)
            restart_revolt
            ;;
        status)
            show_status
            ;;
        logs)
            show_logs
            ;;
        backup)
            backup_data
            ;;
        update)
            check_docker
            update_revolt
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            print_error "Unknown command: $1"
            show_help
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@" 
