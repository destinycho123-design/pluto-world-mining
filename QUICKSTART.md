# Quick Setup Guide

## Prerequisites Check

Before starting, ensure you have:

```bash
# Check Node.js version (need 18+)
node --version

# Check yarn (or use npm)
yarn --version

# Check PostgreSQL (need 14+)
psql --version
```

If any are missing:
- **Node.js**: Download from https://nodejs.org/ (v18 or higher)
- **Yarn**: `npm install -g yarn`
- **PostgreSQL**: Download from https://www.postgresql.org/

---

## Step 1: Clone Repository

```bash
git clone https://github.com/destinycho123-design/pluto-world-mining.git
cd pluto-world-mining
```

---

## Step 2: Install Dependencies

```bash
# Install all dependencies for both apps
yarn install

# This installs packages for:
# - Root workspace
# - apps/api (NestJS backend)
# - apps/web (Next.js frontend)
```

**Output should show:**
```
✓ Installed dependencies
✓ Generated Prisma client
```

---

## Step 3: Setup Environment Variables

```bash
# Copy example files
cp .env.example .env.local
cp apps/api/.env.example apps/api/.env
cp apps/web/.env.example apps/web/.env
```

### Edit `apps/api/.env`

```env
# Database - Make sure PostgreSQL is running
DATABASE_URL=postgresql://investment_user:investment_password@localhost:5432/investment_broker

# Keep these as-is for development
JWT_SECRET=dev-secret-key-change-in-production
JWT_EXPIRATION=24h
API_PORT=3001

# Admin credentials
ADMIN_EMAIL=admin@investment-broker.com
ADMIN_PASSWORD=admin123

# Email (optional for development)
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USER=your-email@gmail.com
MAIL_PASSWORD=your-app-password
```

### Edit `apps/web/.env`

```env
NEXT_PUBLIC_API_URL=http://localhost:3001
```

---

## Step 4: Setup PostgreSQL Database

### Option A: Using Docker (Recommended)

```bash
# Start PostgreSQL in Docker
docker-compose up -d postgres

# Wait 5 seconds for database to start
sleep 5

# Run migrations
cd apps/api
npx prisma migrate dev --name init
cd ../..
```

### Option B: Manual PostgreSQL Setup

```bash
# Create database
sudo -u postgres createdb investment_broker

# Create user
sudo -u postgres createuser investment_user

# Set password
sudo -u postgres psql -c "ALTER USER investment_user WITH PASSWORD 'investment_password';"

# Grant privileges
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE investment_broker TO investment_user;"

# Run migrations
cd apps/api
npx prisma migrate dev --name init
cd ../..
```

**Expected output:**
```
✓ Created 8 migrations
✓ Database synced
✓ Generated Prisma client
```

---

## Step 5: Start Development Servers

```bash
# From project root, start both API and Web
yarn dev
```

**Expected output:**
```
api    - Listening on http://localhost:3001
web    - Listening on http://localhost:3000
```

---

## ✅ Success! Access the Application

### Admin Dashboard
- **URL:** http://localhost:3000
- **Email:** admin@investment-broker.com
- **Password:** admin123

### API Server
- **URL:** http://localhost:3001
- **Health Check:** http://localhost:3001/health (if endpoint exists)

### Database UI (Optional)
- **URL:** http://localhost:8080
- Only if using `docker-compose up`

---

## 🔧 Troubleshooting

### Port Already in Use

```bash
# Find process using port 3001
lsof -i :3001

# Kill process
kill -9 <PID>
```

### Database Connection Failed

```bash
# Check PostgreSQL is running
sudo systemctl status postgresql

# Test connection
psql -U investment_user -d investment_broker -c "SELECT 1;"

# If fails, check DATABASE_URL in apps/api/.env
```

### Prisma Issues

```bash
# Regenerate Prisma client
cd apps/api
npx prisma generate

# Reset database (CAUTION: Deletes all data)
npx prisma migrate reset --force
```

### Yarn Install Issues

```bash
# Clear cache and reinstall
rm -rf node_modules
rm yarn.lock
yarn install
```

### API won't start

```bash
# Check Node environment
echo $NODE_ENV

# Install dependencies explicitly
cd apps/api
npm install
npm run build
cd ../.
```

---

## 📋 Useful Commands

```bash
# Development
yarn dev              # Start both API and Web

# API only
cd apps/api && yarn dev

# Web only
cd apps/web && yarn dev

# Database
cd apps/api
npx prisma studio   # Open database GUI
npx prisma migrate dev --name "description"  # Create migration
npx prisma migrate reset --force  # Reset database

# Building
yarn build           # Build all apps

# Using Makefile
make setup           # Full setup
make dev            # Start dev
make db-reset       # Reset database
make docker         # Docker setup
```

---

## 🚀 Docker Alternative

If you prefer everything in Docker:

```bash
# Build and run everything
docker-compose up --build

# Access:
# - Frontend: http://localhost:3000
# - API: http://localhost:3001
# - Database Admin: http://localhost:8080
```

---

## 📁 Project Structure

```
pluto-world-mining/
├── apps/
│   ├── api/                 # NestJS backend
│   │   ├── src/
│   │   ├── package.json
│   │   └── .env
│   └── web/                 # Next.js frontend
│       ├── src/pages/
│       ├── package.json
│       └── .env
├── prisma/
│   └── schema.prisma       # Database schema
├── package.json            # Root workspace
├── .env.local              # Root env
└── Makefile
```

---

## 🔑 Admin Features Available

Once logged in:

- ✅ **KYC Management** - Review and approve user documents
- ✅ **Withdrawal Approval** - Approve/reject user withdrawals
- ✅ **Billing** - Manage invoices and exports
- ✅ **Settings** - Toggle features on/off, set fees
- ✅ **Reports** - View analytics and statistics

---

## 💡 Next Steps

1. **Explore the admin dashboard** - Try all features
2. **Create test users** - Register new accounts
3. **Test KYC flow** - Upload documents and approve
4. **Test withdrawal flow** - Request and complete withdrawals
5. **Check the database** - Use Prisma Studio to inspect data

---

## 📞 Need Help?

If you encounter issues:

1. Check the **Troubleshooting** section above
2. Review logs: `yarn dev` shows all errors
3. Check `.env` files are correctly configured
4. Ensure PostgreSQL is running
5. Try: `rm -rf node_modules && yarn install`

---

## ✨ You're All Set!

Your investment broker platform is ready to use. Happy coding! 🎉
