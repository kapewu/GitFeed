//
//  GithubEvent.swift
//  Github Feed
//
//  Created by Beniamin Idziak on 12/07/2020.
//  Copyright © 2020 Beniamin Idziak. All rights reserved.
//

import Foundation
import UIKit.UIColor

struct GithubEvent: Codable {
    let id: String
    let type: EventType
    let actor: Actor
    let repo: Repo
    let payload: Payload
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id, type, actor, repo, payload
        case createdAt = "created_at"
    }
}

extension GithubEvent {
    public var readableDate: String? {
        let components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: createdAt, to: Date())
        
        if let day = components.day, day >= 1 {
            return day == 1 ? "about 1 day ago" : "about \(day) days ago"
        } else if let hour = components.hour, hour > 1 {
            return "about \(hour) hours ago"
        } else if let minute = components.minute, minute > 1 {
            return "about \(minute) minutes ago"
        } else if let second = components.second {
            return "about \(second) seconds ago"
        } else {
            return nil
        }
    }
    
    private var actorString: NSMutableAttributedString {
        return NSMutableAttributedString(string: "\(actor.login) ")
    }
    
    private var actionString: NSMutableAttributedString {
        switch type {
        case .CommitCommentEvent:
            return NSMutableAttributedString(string: "created commit comment ")
        case .CreateEvent:
            return NSMutableAttributedString(string: "created " )
        case .DeleteEvent:
             return NSMutableAttributedString(string: "deleted ")
        case .ForkEvent:
            return NSMutableAttributedString(string: "forked ")
        case .GollumEvent:
            return NSMutableAttributedString(string: "created or updated wiki page ")
        case .IssueCommentEvent:
            return NSMutableAttributedString(string: "\(payload.action!.rawValue) issue comment ")
        case .IssuesEvent:
            return NSMutableAttributedString(string: "\(payload.action!.rawValue) issue ")
        case .MemberEvent:
             return NSMutableAttributedString(string: "added new member ")
        case .PublicEvent:
            return NSMutableAttributedString(string: "published ")
        case .PullRequestEvent:
            return NSMutableAttributedString(string: "\(payload.action!.rawValue) pull request ")
        case .PullRequestReviewCommentEvent:
            return NSMutableAttributedString(string: "\(payload.action!.rawValue) pull request comment ")
        case .PushEvent:
            return NSMutableAttributedString(string: "pushed to ")
        case .ReleaseEvent:
            return NSMutableAttributedString(string: "\(payload.action!.rawValue) ")
        case .SponsorshipEvent:
            return NSMutableAttributedString(string: "\(payload.action!.rawValue) sponsorship listing ")
        case .WatchEvent:
            return NSMutableAttributedString(string: "starred ")
        }
    }
    
    private var payloadString: NSMutableAttributedString? {
        let attributes = [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)]
        switch type {
        case .CreateEvent, .DeleteEvent:
            return NSMutableAttributedString(string: "\(payload.refType!) ", attributes: attributes)
        case .PushEvent:
            return NSMutableAttributedString(string: "\(payload.ref!.split(separator: "/").last!) ", attributes: attributes)
        case .ForkEvent:
            return NSMutableAttributedString(string: "\(payload.forkee!.name) ", attributes: attributes)
        default:
            return nil
        }
    }
    
    private var prepositionString: NSMutableAttributedString? {
        switch type {
        case .CreateEvent, .DeleteEvent, .IssueCommentEvent, .IssuesEvent:
            return NSMutableAttributedString(string: "in ")
        case .ForkEvent, .MemberEvent:
            return NSMutableAttributedString(string: "to ")
        case .PushEvent:
            return NSMutableAttributedString(string: "at ")
        default:
            return nil
        }
    }
    
    private var repoString: NSMutableAttributedString? {
        let attributes = [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)]
        switch type {
        case .CommitCommentEvent, .GollumEvent, .SponsorshipEvent:
            return nil
        default:
            return NSMutableAttributedString(string: "\(repo.name)", attributes: attributes)
        }
    }
    
    public var eventDescription: NSMutableAttributedString {
        let eventDescription: NSMutableAttributedString = actorString
        eventDescription.append(actionString)
        
        if let payloadString = payloadString {
            eventDescription.append(payloadString)
        }
        if let prepositionString = prepositionString {
            eventDescription.append(prepositionString)
        }
        if let repoString = repoString {
            eventDescription.append(repoString)
        }
        return eventDescription
    }
}

struct Actor: Codable {
    let id: Int
    let login: String
    let displayLogin: String?
    let url: String
    let avatarURL: String?
}

struct Payload: Codable {
    let action: Action?
    let ref: String?
    let refType: String?
    let forkee: Forkee?
    
    enum CodingKeys: String, CodingKey {
        case refType = "ref_type"
        case action, ref, forkee
    }
}

struct Forkee: Codable {
    let name: String
    let fullName: String?
}

enum Action: String, Codable {
    case started, created, published, opened, closed, reopened, assigned, unassigned
    case review_requested, review_request_removed, labeled, unlabeled, synchronize, added, edited, deleted
}

struct Repo: Codable {
    let id: Int
    let name: String
    let url: String
}

enum EventType: String, Codable {
    case CommitCommentEvent, CreateEvent, DeleteEvent, ForkEvent, GollumEvent, IssueCommentEvent, IssuesEvent
    case MemberEvent, PublicEvent, PullRequestEvent, PullRequestReviewCommentEvent, PushEvent, ReleaseEvent, SponsorshipEvent, WatchEvent
}
