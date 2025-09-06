# Gamification Guide - REChain VC Lab

## 🎮 Gamification Overview

This document outlines our comprehensive gamification strategy for REChain VC Lab, covering user engagement, achievement systems, rewards, and interactive features that make the platform more engaging and fun.

## 🎯 Gamification Principles

### Core Principles

#### 1. User Engagement
- **Intrinsic Motivation**: Foster internal motivation and satisfaction
- **Extrinsic Rewards**: Provide external rewards and recognition
- **Social Interaction**: Encourage community and collaboration
- **Progress Tracking**: Show clear progress and achievements

#### 2. Behavioral Design
- **Clear Goals**: Define clear, achievable objectives
- **Immediate Feedback**: Provide instant feedback on actions
- **Progressive Difficulty**: Gradually increase challenge levels
- **Meaningful Choices**: Offer meaningful decisions and consequences

#### 3. Psychological Triggers
- **Achievement**: Sense of accomplishment and mastery
- **Competition**: Healthy competition and leaderboards
- **Collection**: Collecting items, badges, and rewards
- **Social Status**: Recognition and status within community

#### 4. Platform Integration
- **Seamless Experience**: Integrate naturally with platform features
- **Cross-Platform**: Consistent experience across all devices
- **Personalization**: Adapt to individual user preferences
- **Accessibility**: Inclusive design for all users

## 🏆 Achievement System

### Achievement Categories

#### 1. Web3 Achievements
```typescript
// types/achievements.types.ts
export interface Achievement {
  id: string;
  name: string;
  description: string;
  category: AchievementCategory;
  type: AchievementType;
  requirements: AchievementRequirement[];
  rewards: Reward[];
  rarity: Rarity;
  icon: string;
  unlockedAt?: Date;
  progress?: number;
  maxProgress?: number;
}

export enum AchievementCategory {
  WEB3 = 'web3',
  WEB4 = 'web4',
  WEB5 = 'web5',
  SOCIAL = 'social',
  LEARNING = 'learning',
  CREATION = 'creation',
  COLLABORATION = 'collaboration'
}

export enum AchievementType {
  SINGLE = 'single',
  PROGRESSIVE = 'progressive',
  MILESTONE = 'milestone',
  CHALLENGE = 'challenge',
  COLLECTION = 'collection'
}

export interface AchievementRequirement {
  type: RequirementType;
  target: number;
  current: number;
  description: string;
}

export enum RequirementType {
  TRANSACTIONS = 'transactions',
  WALLETS_CREATED = 'wallets_created',
  NFTS_MINTED = 'nfts_minted',
  DEFI_PROTOCOLS = 'defi_protocols',
  MOVEMENTS_JOINED = 'movements_joined',
  CONTENT_CREATED = 'content_created',
  COLLABORATIONS = 'collaborations',
  LEARNING_MODULES = 'learning_modules',
  COMMUNITY_POSTS = 'community_posts',
  REFERRALS = 'referrals'
}
```

#### 2. Achievement Examples
```typescript
// data/achievements.ts
export const WEB3_ACHIEVEMENTS: Achievement[] = [
  {
    id: 'first_transaction',
    name: 'First Steps',
    description: 'Complete your first blockchain transaction',
    category: AchievementCategory.WEB3,
    type: AchievementType.SINGLE,
    requirements: [
      {
        type: RequirementType.TRANSACTIONS,
        target: 1,
        current: 0,
        description: 'Complete 1 transaction'
      }
    ],
    rewards: [
      {
        type: RewardType.XP,
        amount: 100,
        description: '100 XP'
      },
      {
        type: RewardType.BADGE,
        amount: 1,
        description: 'First Steps Badge'
      }
    ],
    rarity: Rarity.COMMON,
    icon: '🚀'
  },
  {
    id: 'defi_explorer',
    name: 'DeFi Explorer',
    description: 'Interact with 5 different DeFi protocols',
    category: AchievementCategory.WEB3,
    type: AchievementType.PROGRESSIVE,
    requirements: [
      {
        type: RequirementType.DEFI_PROTOCOLS,
        target: 5,
        current: 0,
        description: 'Use 5 DeFi protocols'
      }
    ],
    rewards: [
      {
        type: RewardType.XP,
        amount: 500,
        description: '500 XP'
      },
      {
        type: RewardType.BADGE,
        amount: 1,
        description: 'DeFi Explorer Badge'
      },
      {
        type: RewardType.TOKEN,
        amount: 10,
        description: '10 REChain Tokens'
      }
    ],
    rarity: Rarity.RARE,
    icon: '🏦'
  },
  {
    id: 'nft_collector',
    name: 'NFT Collector',
    description: 'Mint 10 unique NFTs',
    category: AchievementCategory.WEB3,
    type: AchievementType.PROGRESSIVE,
    requirements: [
      {
        type: RequirementType.NFTS_MINTED,
        target: 10,
        current: 0,
        description: 'Mint 10 NFTs'
      }
    ],
    rewards: [
      {
        type: RewardType.XP,
        amount: 1000,
        description: '1000 XP'
      },
      {
        type: RewardType.BADGE,
        amount: 1,
        description: 'NFT Collector Badge'
      },
      {
        type: RewardType.TOKEN,
        amount: 50,
        description: '50 REChain Tokens'
      }
    ],
    rarity: Rarity.EPIC,
    icon: '🎨'
  }
];

export const WEB4_ACHIEVEMENTS: Achievement[] = [
  {
    id: 'movement_creator',
    name: 'Movement Creator',
    description: 'Create your first Web4 movement',
    category: AchievementCategory.WEB4,
    type: AchievementType.SINGLE,
    requirements: [
      {
        type: RequirementType.MOVEMENTS_JOINED,
        target: 1,
        current: 0,
        description: 'Create 1 movement'
      }
    ],
    rewards: [
      {
        type: RewardType.XP,
        amount: 200,
        description: '200 XP'
      },
      {
        type: RewardType.BADGE,
        amount: 1,
        description: 'Movement Creator Badge'
      }
    ],
    rarity: Rarity.COMMON,
    icon: '🌍'
  },
  {
    id: 'social_activist',
    name: 'Social Activist',
    description: 'Join 5 different movements',
    category: AchievementCategory.WEB4,
    type: AchievementType.PROGRESSIVE,
    requirements: [
      {
        type: RequirementType.MOVEMENTS_JOINED,
        target: 5,
        current: 0,
        description: 'Join 5 movements'
      }
    ],
    rewards: [
      {
        type: RewardType.XP,
        amount: 750,
        description: '750 XP'
      },
      {
        type: RewardType.BADGE,
        amount: 1,
        description: 'Social Activist Badge'
      },
      {
        type: RewardType.TOKEN,
        amount: 25,
        description: '25 REChain Tokens'
      }
    ],
    rarity: Rarity.RARE,
    icon: '✊'
  }
];

export const WEB5_ACHIEVEMENTS: Achievement[] = [
  {
    id: 'content_creator',
    name: 'Content Creator',
    description: 'Create your first Web5 content',
    category: AchievementCategory.WEB5,
    type: AchievementType.SINGLE,
    requirements: [
      {
        type: RequirementType.CONTENT_CREATED,
        target: 1,
        current: 0,
        description: 'Create 1 piece of content'
      }
    ],
    rewards: [
      {
        type: RewardType.XP,
        amount: 150,
        description: '150 XP'
      },
      {
        type: RewardType.BADGE,
        amount: 1,
        description: 'Content Creator Badge'
      }
    ],
    rarity: Rarity.COMMON,
    icon: '📝'
  },
  {
    id: 'creative_genius',
    name: 'Creative Genius',
    description: 'Create 20 pieces of content',
    category: AchievementCategory.WEB5,
    type: AchievementType.PROGRESSIVE,
    requirements: [
      {
        type: RequirementType.CONTENT_CREATED,
        target: 20,
        current: 0,
        description: 'Create 20 pieces of content'
      }
    ],
    rewards: [
      {
        type: RewardType.XP,
        amount: 2000,
        description: '2000 XP'
      },
      {
        type: RewardType.BADGE,
        amount: 1,
        description: 'Creative Genius Badge'
      },
      {
        type: RewardType.TOKEN,
        amount: 100,
        description: '100 REChain Tokens'
      }
    ],
    rarity: Rarity.LEGENDARY,
    icon: '🎭'
  }
];
```

## 🎯 Points and XP System

### Experience Points (XP)

#### 1. XP Calculation
```typescript
// services/xp.service.ts
export class XPService {
  private xpMultipliers: Map<string, number> = new Map();
  
  constructor() {
    this.initializeMultipliers();
  }
  
  private initializeMultipliers() {
    this.xpMultipliers.set('transaction', 10);
    this.xpMultipliers.set('wallet_created', 25);
    this.xpMultipliers.set('nft_minted', 50);
    this.xpMultipliers.set('defi_protocol', 30);
    this.xpMultipliers.set('movement_joined', 40);
    this.xpMultipliers.set('movement_created', 100);
    this.xpMultipliers.set('content_created', 35);
    this.xpMultipliers.set('collaboration', 60);
    this.xpMultipliers.set('learning_module', 20);
    this.xpMultipliers.set('community_post', 15);
    this.xpMultipliers.set('referral', 75);
  }
  
  calculateXP(action: string, baseValue: number = 1): number {
    const multiplier = this.xpMultipliers.get(action) || 1;
    return baseValue * multiplier;
  }
  
  async awardXP(userId: string, action: string, baseValue: number = 1): Promise<number> {
    const xp = this.calculateXP(action, baseValue);
    
    // Award XP to user
    await this.addXPToUser(userId, xp);
    
    // Check for level up
    const newLevel = await this.checkLevelUp(userId);
    
    // Trigger achievements
    await this.checkAchievements(userId, action);
    
    return xp;
  }
  
  async addXPToUser(userId: string, xp: number): Promise<void> {
    // Implementation for adding XP to user
    const user = await this.getUser(userId);
    user.totalXP += xp;
    user.currentLevelXP += xp;
    await this.updateUser(user);
  }
  
  async checkLevelUp(userId: string): Promise<number> {
    const user = await this.getUser(userId);
    const requiredXP = this.getRequiredXPForLevel(user.currentLevel + 1);
    
    if (user.currentLevelXP >= requiredXP) {
      user.currentLevel += 1;
      user.currentLevelXP -= requiredXP;
      await this.updateUser(user);
      
      // Trigger level up event
      await this.triggerLevelUpEvent(userId, user.currentLevel);
      
      return user.currentLevel;
    }
    
    return user.currentLevel;
  }
  
  getRequiredXPForLevel(level: number): number {
    // Exponential growth formula
    return Math.floor(100 * Math.pow(1.5, level - 1));
  }
  
  async triggerLevelUpEvent(userId: string, newLevel: number): Promise<void> {
    // Send notification
    await this.sendNotification(userId, {
      type: 'level_up',
      title: 'Level Up!',
      message: `Congratulations! You've reached level ${newLevel}!`,
      rewards: this.getLevelUpRewards(newLevel)
    });
    
    // Award level up rewards
    await this.awardLevelUpRewards(userId, newLevel);
  }
  
  getLevelUpRewards(level: number): Reward[] {
    const rewards: Reward[] = [
      {
        type: RewardType.XP,
        amount: level * 50,
        description: `${level * 50} bonus XP`
      }
    ];
    
    if (level % 5 === 0) {
      rewards.push({
        type: RewardType.TOKEN,
        amount: level * 10,
        description: `${level * 10} REChain Tokens`
      });
    }
    
    if (level % 10 === 0) {
      rewards.push({
        type: RewardType.BADGE,
        amount: 1,
        description: `Level ${level} Badge`
      });
    }
    
    return rewards;
  }
}
```

#### 2. User Levels
```typescript
// types/user.types.ts
export interface User {
  id: string;
  username: string;
  email: string;
  totalXP: number;
  currentLevel: number;
  currentLevelXP: number;
  level: UserLevel;
  badges: Badge[];
  achievements: Achievement[];
  stats: UserStats;
  preferences: UserPreferences;
}

export interface UserLevel {
  level: number;
  name: string;
  description: string;
  requiredXP: number;
  benefits: string[];
  color: string;
  icon: string;
}

export const USER_LEVELS: UserLevel[] = [
  {
    level: 1,
    name: 'Novice',
    description: 'Just getting started',
    requiredXP: 0,
    benefits: ['Basic features access'],
    color: '#6B7280',
    icon: '🌱'
  },
  {
    level: 5,
    name: 'Explorer',
    description: 'Exploring the platform',
    requiredXP: 500,
    benefits: ['Advanced features', 'Priority support'],
    color: '#3B82F6',
    icon: '🔍'
  },
  {
    level: 10,
    name: 'Contributor',
    description: 'Active contributor',
    requiredXP: 1500,
    benefits: ['Beta features', 'Community moderation'],
    color: '#10B981',
    icon: '⭐'
  },
  {
    level: 20,
    name: 'Expert',
    description: 'Platform expert',
    requiredXP: 5000,
    benefits: ['Expert features', 'Mentor status'],
    color: '#F59E0B',
    icon: '🏆'
  },
  {
    level: 50,
    name: 'Master',
    description: 'Platform master',
    requiredXP: 25000,
    benefits: ['All features', 'VIP status'],
    color: '#8B5CF6',
    icon: '👑'
  }
];
```

## 🏅 Badge System

### Badge Categories

#### 1. Badge Types
```typescript
// types/badge.types.ts
export interface Badge {
  id: string;
  name: string;
  description: string;
  category: BadgeCategory;
  rarity: Rarity;
  icon: string;
  color: string;
  requirements: BadgeRequirement[];
  rewards: Reward[];
  unlockedAt?: Date;
  progress?: number;
  maxProgress?: number;
}

export enum BadgeCategory {
  ACHIEVEMENT = 'achievement',
  SKILL = 'skill',
  SOCIAL = 'social',
  CREATIVE = 'creative',
  TECHNICAL = 'technical',
  COMMUNITY = 'community',
  SPECIAL = 'special'
}

export enum Rarity {
  COMMON = 'common',
  UNCOMMON = 'uncommon',
  RARE = 'rare',
  EPIC = 'epic',
  LEGENDARY = 'legendary',
  MYTHIC = 'mythic'
}

export interface BadgeRequirement {
  type: RequirementType;
  target: number;
  current: number;
  description: string;
}
```

#### 2. Badge Examples
```typescript
// data/badges.ts
export const BADGES: Badge[] = [
  // Web3 Badges
  {
    id: 'blockchain_pioneer',
    name: 'Blockchain Pioneer',
    description: 'First to use a new blockchain feature',
    category: BadgeCategory.TECHNICAL,
    rarity: Rarity.RARE,
    icon: '🚀',
    color: '#3B82F6',
    requirements: [
      {
        type: RequirementType.TRANSACTIONS,
        target: 1,
        current: 0,
        description: 'Complete 1 transaction'
      }
    ],
    rewards: [
      {
        type: RewardType.XP,
        amount: 200,
        description: '200 XP'
      }
    ]
  },
  {
    id: 'defi_master',
    name: 'DeFi Master',
    description: 'Master of decentralized finance',
    category: BadgeCategory.TECHNICAL,
    rarity: Rarity.EPIC,
    icon: '🏦',
    color: '#10B981',
    requirements: [
      {
        type: RequirementType.DEFI_PROTOCOLS,
        target: 10,
        current: 0,
        description: 'Use 10 DeFi protocols'
      }
    ],
    rewards: [
      {
        type: RewardType.XP,
        amount: 1000,
        description: '1000 XP'
      },
      {
        type: RewardType.TOKEN,
        amount: 50,
        description: '50 REChain Tokens'
      }
    ]
  },
  
  // Web4 Badges
  {
    id: 'movement_leader',
    name: 'Movement Leader',
    description: 'Lead a successful movement',
    category: BadgeCategory.SOCIAL,
    rarity: Rarity.RARE,
    icon: '👑',
    color: '#F59E0B',
    requirements: [
      {
        type: RequirementType.MOVEMENTS_JOINED,
        target: 1,
        current: 0,
        description: 'Create 1 movement'
      }
    ],
    rewards: [
      {
        type: RewardType.XP,
        amount: 300,
        description: '300 XP'
      }
    ]
  },
  {
    id: 'social_butterfly',
    name: 'Social Butterfly',
    description: 'Very active in the community',
    category: BadgeCategory.SOCIAL,
    rarity: Rarity.UNCOMMON,
    icon: '🦋',
    color: '#EC4899',
    requirements: [
      {
        type: RequirementType.COMMUNITY_POSTS,
        target: 50,
        current: 0,
        description: 'Make 50 community posts'
      }
    ],
    rewards: [
      {
        type: RewardType.XP,
        amount: 500,
        description: '500 XP'
      }
    ]
  },
  
  // Web5 Badges
  {
    id: 'creative_genius',
    name: 'Creative Genius',
    description: 'Exceptional creative content',
    category: BadgeCategory.CREATIVE,
    rarity: Rarity.LEGENDARY,
    icon: '🎨',
    color: '#8B5CF6',
    requirements: [
      {
        type: RequirementType.CONTENT_CREATED,
        target: 100,
        current: 0,
        description: 'Create 100 pieces of content'
      }
    ],
    rewards: [
      {
        type: RewardType.XP,
        amount: 5000,
        description: '5000 XP'
      },
      {
        type: RewardType.TOKEN,
        amount: 200,
        description: '200 REChain Tokens'
      }
    ]
  },
  {
    id: 'collaboration_master',
    name: 'Collaboration Master',
    description: 'Expert at working with others',
    category: BadgeCategory.COMMUNITY,
    rarity: Rarity.EPIC,
    icon: '🤝',
    color: '#06B6D4',
    requirements: [
      {
        type: RequirementType.COLLABORATIONS,
        target: 25,
        current: 0,
        description: 'Complete 25 collaborations'
      }
    ],
    rewards: [
      {
        type: RewardType.XP,
        amount: 2000,
        description: '2000 XP'
      },
      {
        type: RewardType.TOKEN,
        amount: 100,
        description: '100 REChain Tokens'
      }
    ]
  }
];
```

## 🎮 Game Mechanics

### 1. Quests and Challenges

#### Quest System
```typescript
// types/quest.types.ts
export interface Quest {
  id: string;
  title: string;
  description: string;
  type: QuestType;
  category: QuestCategory;
  difficulty: Difficulty;
  requirements: QuestRequirement[];
  rewards: Reward[];
  timeLimit?: number; // in hours
  isActive: boolean;
  createdAt: Date;
  expiresAt?: Date;
}

export enum QuestType {
  DAILY = 'daily',
  WEEKLY = 'weekly',
  MONTHLY = 'monthly',
  SPECIAL = 'special',
  CHAIN = 'chain'
}

export enum QuestCategory {
  WEB3 = 'web3',
  WEB4 = 'web4',
  WEB5 = 'web5',
  SOCIAL = 'social',
  LEARNING = 'learning',
  CREATIVE = 'creative'
}

export enum Difficulty {
  EASY = 'easy',
  MEDIUM = 'medium',
  HARD = 'hard',
  EXPERT = 'expert'
}

export interface QuestRequirement {
  type: RequirementType;
  target: number;
  current: number;
  description: string;
}
```

#### Quest Examples
```typescript
// data/quests.ts
export const DAILY_QUESTS: Quest[] = [
  {
    id: 'daily_transaction',
    title: 'Daily Transaction',
    description: 'Complete a blockchain transaction today',
    type: QuestType.DAILY,
    category: QuestCategory.WEB3,
    difficulty: Difficulty.EASY,
    requirements: [
      {
        type: RequirementType.TRANSACTIONS,
        target: 1,
        current: 0,
        description: 'Complete 1 transaction'
      }
    ],
    rewards: [
      {
        type: RewardType.XP,
        amount: 50,
        description: '50 XP'
      },
      {
        type: RewardType.TOKEN,
        amount: 5,
        description: '5 REChain Tokens'
      }
    ],
    isActive: true,
    createdAt: new Date()
  },
  {
    id: 'daily_content',
    title: 'Daily Creator',
    description: 'Create a piece of content today',
    type: QuestType.DAILY,
    category: QuestCategory.WEB5,
    difficulty: Difficulty.EASY,
    requirements: [
      {
        type: RequirementType.CONTENT_CREATED,
        target: 1,
        current: 0,
        description: 'Create 1 piece of content'
      }
    ],
    rewards: [
      {
        type: RewardType.XP,
        amount: 75,
        description: '75 XP'
      },
      {
        type: RewardType.TOKEN,
        amount: 8,
        description: '8 REChain Tokens'
      }
    ],
    isActive: true,
    createdAt: new Date()
  }
];

export const WEEKLY_QUESTS: Quest[] = [
  {
    id: 'weekly_explorer',
    title: 'Weekly Explorer',
    description: 'Explore 5 different features this week',
    type: QuestType.WEEKLY,
    category: QuestCategory.WEB3,
    difficulty: Difficulty.MEDIUM,
    requirements: [
      {
        type: RequirementType.DEFI_PROTOCOLS,
        target: 5,
        current: 0,
        description: 'Use 5 different features'
      }
    ],
    rewards: [
      {
        type: RewardType.XP,
        amount: 500,
        description: '500 XP'
      },
      {
        type: RewardType.TOKEN,
        amount: 50,
        description: '50 REChain Tokens'
      },
      {
        type: RewardType.BADGE,
        amount: 1,
        description: 'Weekly Explorer Badge'
      }
    ],
    isActive: true,
    createdAt: new Date()
  }
];
```

### 2. Leaderboards

#### Leaderboard System
```typescript
// services/leaderboard.service.ts
export class LeaderboardService {
  async getLeaderboard(type: LeaderboardType, period: LeaderboardPeriod): Promise<LeaderboardEntry[]> {
    const leaderboard = await this.calculateLeaderboard(type, period);
    return leaderboard.slice(0, 100); // Top 100
  }
  
  async calculateLeaderboard(type: LeaderboardType, period: LeaderboardPeriod): Promise<LeaderboardEntry[]> {
    const users = await this.getUsersForPeriod(period);
    
    switch (type) {
      case LeaderboardType.XP:
        return this.calculateXPLeaderboard(users);
      case LeaderboardType.ACHIEVEMENTS:
        return this.calculateAchievementLeaderboard(users);
      case LeaderboardType.BADGES:
        return this.calculateBadgeLeaderboard(users);
      case LeaderboardType.CONTENT:
        return this.calculateContentLeaderboard(users);
      case LeaderboardType.SOCIAL:
        return this.calculateSocialLeaderboard(users);
      default:
        return [];
    }
  }
  
  private calculateXPLeaderboard(users: User[]): LeaderboardEntry[] {
    return users
      .sort((a, b) => b.totalXP - a.totalXP)
      .map((user, index) => ({
        rank: index + 1,
        userId: user.id,
        username: user.username,
        value: user.totalXP,
        displayValue: `${user.totalXP} XP`,
        level: user.currentLevel,
        avatar: user.avatar
      }));
  }
  
  private calculateAchievementLeaderboard(users: User[]): LeaderboardEntry[] {
    return users
      .sort((a, b) => b.achievements.length - a.achievements.length)
      .map((user, index) => ({
        rank: index + 1,
        userId: user.id,
        username: user.username,
        value: user.achievements.length,
        displayValue: `${user.achievements.length} achievements`,
        level: user.currentLevel,
        avatar: user.avatar
      }));
  }
  
  async getUserRank(userId: string, type: LeaderboardType, period: LeaderboardPeriod): Promise<number> {
    const leaderboard = await this.getLeaderboard(type, period);
    const userEntry = leaderboard.find(entry => entry.userId === userId);
    return userEntry ? userEntry.rank : -1;
  }
}

export interface LeaderboardEntry {
  rank: number;
  userId: string;
  username: string;
  value: number;
  displayValue: string;
  level: number;
  avatar?: string;
}

export enum LeaderboardType {
  XP = 'xp',
  ACHIEVEMENTS = 'achievements',
  BADGES = 'badges',
  CONTENT = 'content',
  SOCIAL = 'social'
}

export enum LeaderboardPeriod {
  DAILY = 'daily',
  WEEKLY = 'weekly',
  MONTHLY = 'monthly',
  ALL_TIME = 'all_time'
}
```

### 3. Streaks and Habits

#### Streak System
```typescript
// services/streak.service.ts
export class StreakService {
  async updateStreak(userId: string, action: string): Promise<StreakInfo> {
    const user = await this.getUser(userId);
    const today = new Date().toDateString();
    const lastActionDate = user.lastActionDate?.toDateString();
    
    if (lastActionDate === today) {
      // Already counted today
      return user.streakInfo;
    }
    
    if (lastActionDate === this.getYesterday().toDateString()) {
      // Consecutive day
      user.streakInfo.currentStreak += 1;
    } else if (lastActionDate !== today) {
      // Streak broken
      user.streakInfo.currentStreak = 1;
    }
    
    // Update best streak
    if (user.streakInfo.currentStreak > user.streakInfo.bestStreak) {
      user.streakInfo.bestStreak = user.streakInfo.currentStreak;
    }
    
    user.lastActionDate = new Date();
    await this.updateUser(user);
    
    // Check for streak milestones
    await this.checkStreakMilestones(userId, user.streakInfo.currentStreak);
    
    return user.streakInfo;
  }
  
  async checkStreakMilestones(userId: string, streak: number): Promise<void> {
    const milestones = [3, 7, 14, 30, 60, 100];
    
    if (milestones.includes(streak)) {
      await this.awardStreakMilestone(userId, streak);
    }
  }
  
  async awardStreakMilestone(userId: string, streak: number): Promise<void> {
    const rewards: Reward[] = [
      {
        type: RewardType.XP,
        amount: streak * 10,
        description: `${streak * 10} XP for ${streak}-day streak`
      },
      {
        type: RewardType.TOKEN,
        amount: Math.floor(streak / 7) * 10,
        description: `${Math.floor(streak / 7) * 10} REChain Tokens`
      }
    ];
    
    if (streak >= 30) {
      rewards.push({
        type: RewardType.BADGE,
        amount: 1,
        description: `${streak}-Day Streak Badge`
      });
    }
    
    await this.awardRewards(userId, rewards);
    
    // Send notification
    await this.sendNotification(userId, {
      type: 'streak_milestone',
      title: 'Streak Milestone!',
      message: `Amazing! You've maintained a ${streak}-day streak!`,
      rewards
    });
  }
}

export interface StreakInfo {
  currentStreak: number;
  bestStreak: number;
  lastActionDate?: Date;
}
```

## 🎁 Rewards System

### Reward Types

#### 1. Reward Categories
```typescript
// types/reward.types.ts
export interface Reward {
  type: RewardType;
  amount: number;
  description: string;
  icon?: string;
  color?: string;
}

export enum RewardType {
  XP = 'xp',
  TOKEN = 'token',
  BADGE = 'badge',
  ACHIEVEMENT = 'achievement',
  ITEM = 'item',
  DISCOUNT = 'discount',
  ACCESS = 'access',
  TITLE = 'title',
  AVATAR = 'avatar',
  THEME = 'theme'
}

export interface RewardItem {
  id: string;
  name: string;
  description: string;
  type: RewardType;
  rarity: Rarity;
  icon: string;
  color: string;
  value: number;
  isUnlocked: boolean;
  unlockedAt?: Date;
}
```

#### 2. Reward Shop
```typescript
// data/reward-shop.ts
export const REWARD_SHOP: RewardItem[] = [
  // Avatars
  {
    id: 'avatar_robot',
    name: 'Robot Avatar',
    description: 'A futuristic robot avatar',
    type: RewardType.AVATAR,
    rarity: Rarity.COMMON,
    icon: '🤖',
    color: '#6B7280',
    value: 100,
    isUnlocked: false
  },
  {
    id: 'avatar_astronaut',
    name: 'Astronaut Avatar',
    description: 'An astronaut exploring space',
    type: RewardType.AVATAR,
    rarity: Rarity.RARE,
    icon: '👨‍🚀',
    color: '#3B82F6',
    value: 500,
    isUnlocked: false
  },
  
  // Themes
  {
    id: 'theme_dark',
    name: 'Dark Theme',
    description: 'A sleek dark theme',
    type: RewardType.THEME,
    rarity: Rarity.UNCOMMON,
    icon: '🌙',
    color: '#1F2937',
    value: 200,
    isUnlocked: false
  },
  {
    id: 'theme_neon',
    name: 'Neon Theme',
    description: 'A vibrant neon theme',
    type: RewardType.THEME,
    rarity: Rarity.EPIC,
    icon: '💫',
    color: '#8B5CF6',
    value: 1000,
    isUnlocked: false
  },
  
  // Titles
  {
    id: 'title_blockchain_expert',
    name: 'Blockchain Expert',
    description: 'A title for blockchain experts',
    type: RewardType.TITLE,
    rarity: Rarity.RARE,
    icon: '⛓️',
    color: '#10B981',
    value: 750,
    isUnlocked: false
  },
  {
    id: 'title_creative_master',
    name: 'Creative Master',
    description: 'A title for creative masters',
    type: RewardType.TITLE,
    rarity: Rarity.LEGENDARY,
    icon: '🎨',
    color: '#F59E0B',
    value: 2000,
    isUnlocked: false
  }
];
```

## 📊 Analytics and Insights

### Gamification Analytics

#### 1. User Engagement Metrics
```typescript
// services/gamification-analytics.service.ts
export class GamificationAnalyticsService {
  async getUserEngagementMetrics(userId: string, period: DateRange): Promise<EngagementMetrics> {
    const actions = await this.getUserActions(userId, period);
    
    return {
      totalActions: actions.length,
      uniqueActions: new Set(actions.map(a => a.type)).size,
      averageActionsPerDay: actions.length / period.days,
      streakDays: await this.getCurrentStreak(userId),
      level: await this.getUserLevel(userId),
      totalXP: await this.getTotalXP(userId),
      achievementsUnlocked: await this.getAchievementsUnlocked(userId, period),
      badgesEarned: await this.getBadgesEarned(userId, period)
    };
  }
  
  async getPlatformEngagementMetrics(period: DateRange): Promise<PlatformEngagementMetrics> {
    const users = await this.getActiveUsers(period);
    const actions = await this.getAllActions(period);
    
    return {
      activeUsers: users.length,
      totalActions: actions.length,
      averageActionsPerUser: actions.length / users.length,
      topActions: this.getTopActions(actions),
      engagementRate: await this.getEngagementRate(period),
      retentionRate: await this.getRetentionRate(period),
      churnRate: await this.getChurnRate(period)
    };
  }
  
  async getRewardEffectiveness(): Promise<RewardEffectiveness> {
    const rewards = await this.getAllRewards();
    
    return {
      mostEffectiveRewards: this.getMostEffectiveRewards(rewards),
      leastEffectiveRewards: this.getLeastEffectiveRewards(rewards),
      rewardRedemptionRate: await this.getRewardRedemptionRate(),
      averageTimeToReward: await this.getAverageTimeToReward()
    };
  }
}

export interface EngagementMetrics {
  totalActions: number;
  uniqueActions: number;
  averageActionsPerDay: number;
  streakDays: number;
  level: number;
  totalXP: number;
  achievementsUnlocked: number;
  badgesEarned: number;
}

export interface PlatformEngagementMetrics {
  activeUsers: number;
  totalActions: number;
  averageActionsPerUser: number;
  topActions: ActionStats[];
  engagementRate: number;
  retentionRate: number;
  churnRate: number;
}

export interface RewardEffectiveness {
  mostEffectiveRewards: RewardStats[];
  leastEffectiveRewards: RewardStats[];
  rewardRedemptionRate: number;
  averageTimeToReward: number;
}
```

## 📞 Contact Information

### Gamification Team
- **Email**: gamification@rechain.network
- **Phone**: +1-555-GAMIFICATION
- **Slack**: #gamification channel
- **Office Hours**: Monday-Friday, 9 AM - 5 PM UTC

### UX Team
- **Email**: ux@rechain.network
- **Phone**: +1-555-UX
- **Slack**: #ux channel
- **Office Hours**: Monday-Friday, 9 AM - 5 PM UTC

### Community Team
- **Email**: community@rechain.network
- **Phone**: +1-555-COMMUNITY
- **Slack**: #community channel
- **Office Hours**: Monday-Friday, 9 AM - 5 PM UTC

---

**Making the platform fun and engaging! 🎮**

*This gamification guide is effective as of September 4, 2024, and will be reviewed quarterly.*

**Last Updated**: 2024-09-04
**Version**: 1.0.0
**Gamification Guide Version**: 1.0.0
