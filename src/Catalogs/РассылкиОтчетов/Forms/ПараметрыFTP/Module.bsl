///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	РеквизитыСправочника = Метаданные.Справочники.РассылкиОтчетов.Реквизиты;
	Элементы.СерверИКаталог.Подсказка      = РеквизитыСправочника.FTPКаталог.Подсказка;
	Элементы.Порт.Подсказка                = РеквизитыСправочника.FTPПорт.Подсказка;
	Элементы.Логин.Подсказка               = РеквизитыСправочника.FTPЛогин.Подсказка;
	Элементы.ПассивноеСоединение.Подсказка = РеквизитыСправочника.FTPПассивноеСоединение.Подсказка;
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "Сервер, Каталог, Порт, Логин, Пароль, ПассивноеСоединение");
	Если ЭтотОбъект.Сервер = "" Тогда
		ЭтотОбъект.Сервер = "сервер";
	КонецЕсли;
	Если ЭтотОбъект.Каталог = "" Тогда
		ЭтотОбъект.Каталог = "/каталог/";
	КонецЕсли;
	ВидимостьДоступность(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СерверИКаталогПриИзменении(Элемент)
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, РассылкаОтчетовКлиент.РазобратьFTPАдрес(СерверИКаталог), "Сервер, Каталог");
	ВидимостьДоступность(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	Если Сервер = "" Тогда
		ПолныйАдрес = НСтр("ru = 'ftp://логин:пароль@сервер:порт/каталог/'; en = 'ftp://login:password@server:port/directory/'");
	Иначе
		Если Логин = "" Тогда
			ПолныйАдрес = "ftp://"+ Сервер +":"+ Формат(Порт, "ЧН=21; ЧГ=0") + Каталог;
		Иначе
			ПолныйАдрес = "ftp://"+ Логин +":"+ ?(ЗначениеЗаполнено(Пароль), ПарольСкрыт(), "") +"@"+ Сервер +":"+ Формат(Порт, "ЧН=0; ЧГ=0") + Каталог;
		КонецЕсли;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("ЗаполнитьЗавершение", ЭтотОбъект);
	ПоказатьВводСтроки(Обработчик, ПолныйАдрес, НСтр("ru = 'Введите полный ftp адрес'; en = 'Enter full ftp address'"))
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	ЗначениеВыбора = Новый Структура("Сервер, Каталог, Порт, Логин, Пароль, ПассивноеСоединение");
	ЗаполнитьЗначенияСвойств(ЗначениеВыбора, ЭтотОбъект);
	ОповеститьОВыборе(ЗначениеВыбора);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ВидимостьДоступность(Форма, Изменения = "")
	Если Не СтрЗаканчиваетсяНа(Форма.Каталог, "/") Тогда
		Форма.Каталог = Форма.Каталог + "/";
	КонецЕсли;
	Форма.СерверИКаталог = "ftp://"+ Форма.Сервер + Форма.Каталог;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЗавершение(РезультатВвода, ДополнительныеПараметры) Экспорт
	Если РезультатВвода <> Неопределено Тогда
		ПарольДоВвода = Пароль;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, РассылкаОтчетовКлиент.РазобратьFTPАдрес(РезультатВвода));
		Если Пароль = ПарольСкрыт() Тогда
			Пароль = ПарольДоВвода;
		КонецЕсли;
		ВидимостьДоступность(ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция ПарольСкрыт()
	Возврат "********";
КонецФункции

#КонецОбласти
