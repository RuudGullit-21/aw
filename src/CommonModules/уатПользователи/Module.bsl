////////////////////////////////////////////////////////////////////////////////
// Подсистема "Пользователи".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Позволяет указать роли специального назначения. Все остальные роли не требуется указывать -
// это роли, которые предназначены для любых пользователей, кроме внешних пользователей.
//
// Параметры:
//  НазначениеРолей - Структура - со свойствами:
//   * ТолькоДляАдминистраторовСистемы - Массив - имена ролей, которые при выключенном разделении
//     предназначены для любых пользователей, кроме внешних пользователей, а в разделенном режиме
//     предназначены только для администраторов сервиса, например:
//       Администрирование, ОбновлениеКонфигурацииБазыДанных, АдминистраторСистемы,
//     а также все роли с правами:
//       Администрирование,
//       Администрирование расширений конфигурации,
//       Обновление конфигурации базы данных.
//     Такие роли, как правило, существуют только в БСП и не встречаются в прикладных решениях.
//
//   * ТолькоДляПользователейСистемы - Массив - имена ролей, которые при выключенном разделении
//     предназначены для любых пользователей, кроме внешних пользователей, а в разделенном режиме
//     предназначены только для неразделенных пользователей (сотрудников технической поддержки сервиса и
//     администраторов сервиса), например:
//       ДобавлениеИзменениеАдресныхСведений, ДобавлениеИзменениеБанков,
//     а также все роли с правами изменения неразделенных данных и следующими правами:
//       Толстый клиент,
//       Внешнее соединение,
//       Automation,
//       Режим все функции,
//       Интерактивное открытие внешних обработок,
//       Интерактивное открытие внешних отчетов.
//     Такие роли в большей части существует в БСП, но могут встречаться и в прикладных решениях.
//
//   * ТолькоДляВнешнихПользователей - Массив - имена ролей, которые предназначены
//     только для внешних пользователей (роли со специально разработанным набором прав), например:
//       ДобавлениеИзменениеОтветовНаВопросыАнкет, БазовыеПраваВнешнихПользователейБСП.
//     Такие роли существуют и в БСП, и в прикладных решениях (если используются внешние пользователи).
//
//   * СовместноДляПользователейИВнешнихПользователей - Массив - имена ролей, которые предназначены
//     для любых пользователей (и внутренних, и внешних, и неразделенных), например:
//       ЧтениеОтветовНаВопросыАнкет, ИспользованиеВариантовОтчетов.
//     Такие роли существуют и в БСП, и в прикладных решениях (если используются внешние пользователи).
//
Процедура ПриОпределенииНазначенияРолей(НазначениеРолей) Экспорт
	
	НазначениеРолей.СовместноДляПользователейИВнешнихПользователей.Добавить(Метаданные.Роли.уатБазовыеПрава.Имя);
	
	Если Не Метаданные.Роли.Найти("уатВнешнийПользовательПотребностьВПеревозке") = Неопределено Тогда 
		НазначениеРолей.ТолькоДляВнешнихПользователей.Добавить("уатВнешнийПользовательПотребностьВПеревозке");
	КонецЕсли;
	
	Если Не Метаданные.Роли.Найти("уатБазовыеПраваВнешнихПользователей") = Неопределено Тогда 
		НазначениеРолей.ТолькоДляВнешнихПользователей.Добавить("уатБазовыеПраваВнешнихПользователей");
	КонецЕсли;
	
	Если Не Метаданные.Роли.Найти("уатВнешнийПользовательПеревозчик") = Неопределено Тогда 
		НазначениеРолей.ТолькоДляВнешнихПользователей.Добавить("уатВнешнийПользовательПеревозчик");
	КонецЕсли;
	
	Если Не Метаданные.Роли.Найти("уатВнешнийПользовательЗаказчик") = Неопределено Тогда 
		НазначениеРолей.ТолькоДляВнешнихПользователей.Добавить("уатВнешнийПользовательЗаказчик");
	КонецЕсли;
	
	Если Не Метаданные.Роли.Найти("уатВнешнийПользовательПеревозчик") = Неопределено Тогда 
		НазначениеРолей.ТолькоДляВнешнихПользователей.Добавить("уатВнешнийПользовательЗаказНаТС");
	КонецЕсли;
	
	НазначениеРолей.СовместноДляПользователейИВнешнихПользователей.Добавить(Метаданные.Роли.ИзменениеВыполнениеЗадач.Имя);
	НазначениеРолей.СовместноДляПользователейИВнешнихПользователей.Добавить(Метаданные.Роли.слкУправлениеМенеджеромЛицензийСЛК.Имя);
	
КонецПроцедуры

#КонецОбласти
