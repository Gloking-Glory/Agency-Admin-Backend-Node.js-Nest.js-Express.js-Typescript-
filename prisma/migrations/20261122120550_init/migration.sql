-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('ADMIN', 'AGENCY');

-- CreateEnum
CREATE TYPE "EmailIdentityStatus" AS ENUM ('ACTIVE', 'ARCHIVED', 'RELEASED');

-- CreateEnum
CREATE TYPE "ArchiveStatus" AS ENUM ('ARCHIVED', 'RESTORED', 'CLOSED');

-- CreateTable
CREATE TABLE "User" (
    "id" UUID NOT NULL,
    "passwordHash" TEXT NOT NULL,
    "role" "UserRole" NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "emailIdentityId" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AdminProfile" (
    "id" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "isSuperAdmin" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "AdminProfile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AgencyProfile" (
    "id" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "companyName" TEXT NOT NULL,
    "address" TEXT NOT NULL,
    "contactDetails" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "AgencyProfile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EmailIdentity" (
    "id" UUID NOT NULL,
    "normalizedEmail" TEXT NOT NULL,
    "status" "EmailIdentityStatus" NOT NULL DEFAULT 'ACTIVE',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "EmailIdentity_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AccountArchive" (
    "id" UUID NOT NULL,
    "originalUserId" UUID NOT NULL,
    "originalProfileId" UUID NOT NULL,
    "emailIdentityId" UUID NOT NULL,
    "role" "UserRole" NOT NULL,
    "normalizedEmail" TEXT NOT NULL,
    "deletionReason" TEXT NOT NULL,
    "snapshot" JSONB NOT NULL,
    "deletedByUserId" UUID NOT NULL,
    "deletedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "status" "ArchiveStatus" NOT NULL DEFAULT 'ARCHIVED',
    "restoredAt" TIMESTAMP(3),
    "restoredByUserId" UUID,
    "emailReleasedAt" TIMESTAMP(3),
    "emailReleasedByUserId" UUID,

    CONSTRAINT "AccountArchive_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_emailIdentityId_key" ON "User"("emailIdentityId");

-- CreateIndex
CREATE UNIQUE INDEX "AdminProfile_userId_key" ON "AdminProfile"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "AgencyProfile_userId_key" ON "AgencyProfile"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "EmailIdentity_normalizedEmail_key" ON "EmailIdentity"("normalizedEmail");

-- CreateIndex
CREATE INDEX "AccountArchive_originalUserId_idx" ON "AccountArchive"("originalUserId");

-- CreateIndex
CREATE INDEX "AccountArchive_emailIdentityId_idx" ON "AccountArchive"("emailIdentityId");

-- CreateIndex
CREATE INDEX "AccountArchive_normalizedEmail_idx" ON "AccountArchive"("normalizedEmail");

-- CreateIndex
CREATE INDEX "AccountArchive_status_deletedAt_idx" ON "AccountArchive"("status", "deletedAt");

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_emailIdentityId_fkey" FOREIGN KEY ("emailIdentityId") REFERENCES "EmailIdentity"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AdminProfile" ADD CONSTRAINT "AdminProfile_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AgencyProfile" ADD CONSTRAINT "AgencyProfile_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AccountArchive" ADD CONSTRAINT "AccountArchive_emailIdentityId_fkey" FOREIGN KEY ("emailIdentityId") REFERENCES "EmailIdentity"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
