
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("ОтборПоВодителям", ПолучитьВодителейИзМаршрутныхЛистов(ПараметрКоманды));
	
	ОткрытьФорму(
		"Обработка.уатСообщенияМобильногоПриложения.Форма", 
		ПараметрыФормы, 
		ПараметрыВыполненияКоманды.Источник, 
		ПараметрыВыполненияКоманды.Уникальность, 
		ПараметрыВыполненияКоманды.Окно, 
		ПараметрыВыполненияКоманды.НавигационнаяСсылка
	);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьВодителейИзМаршрутныхЛистов(Знач МаршрутныеЛисты)
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("мсвМаршрутныхЛистов", МаршрутныеЛисты);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	уатМаршрутныйЛист.Водитель1 КАК Водитель
	|ИЗ
	|	Документ.уатМаршрутныйЛист КАК уатМаршрутныйЛист
	|ГДЕ
	|	уатМаршрутныйЛист.Ссылка В(&мсвМаршрутныхЛистов)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	уатМаршрутныйЛист.Водитель2
	|ИЗ
	|	Документ.уатМаршрутныйЛист КАК уатМаршрутныйЛист
	|ГДЕ
	|	уатМаршрутныйЛист.Ссылка В(&мсвМаршрутныхЛистов)";
	
	мсвВодители = Новый Массив();
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл 
		Если Не ЗначениеЗаполнено(Выборка.Водитель) Тогда 
			Продолжить;
		КонецЕсли;
		
		Если ТипЗнч(Выборка.Водитель) = Тип("СправочникСсылка.Сотрудники") Тогда 
			мсвВодители.Добавить(Выборка.Водитель.ФизическоеЛицо);
		Иначе 
			мсвВодители.Добавить(Выборка.Водитель);
		КонецЕсли;
	КонецЦикла;
	
	Возврат мсвВодители;
	
КонецФункции // ПолучитьВодителейИзМаршрутныхЛистов()

#КонецОбласти
